import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "button", "status"]

  connect() {
    this.mediaRecorder = null
    this.audioChunks = []
    this.isRecording = false
  }

  async toggle() {
    if (this.isRecording) {
      this.stop()
    } else {
      await this.start()
    }
  }

  getSupportedMimeType() {
    // Safari only supports mp4, Chrome/Firefox support webm
    const types = [
      'audio/webm;codecs=opus',
      'audio/webm',
      'audio/mp4',
      'audio/aac',
      'audio/mpeg'
    ]

    for (const type of types) {
      if (MediaRecorder.isTypeSupported(type)) {
        return type
      }
    }
    return null
  }

  getFileExtension(mimeType) {
    if (mimeType.includes('mp4') || mimeType.includes('aac') || mimeType.includes('mpeg')) {
      return 'mp4'
    }
    return 'webm'
  }

  async start() {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true })

      const mimeType = this.getSupportedMimeType()
      if (!mimeType) {
        throw new Error('No supported audio format')
      }

      this.currentMimeType = mimeType
      this.mediaRecorder = new MediaRecorder(stream, { mimeType })
      this.audioChunks = []

      this.mediaRecorder.ondataavailable = (event) => {
        if (event.data.size > 0) {
          this.audioChunks.push(event.data)
        }
      }

      this.mediaRecorder.onstop = () => {
        // Stop all tracks to release microphone
        stream.getTracks().forEach(track => track.stop())
        this.sendAudioForTranscription()
      }

      this.mediaRecorder.start()
      this.isRecording = true
      this.updateUI('recording')

    } catch (error) {
      console.error('Microphone access error:', error)
      if (error.name === 'NotAllowedError' || error.name === 'PermissionDeniedError') {
        this.showError('Microphone non autorise')
      } else if (error.name === 'NotFoundError') {
        this.showError('Aucun microphone detecte')
      } else {
        this.showError('Erreur: ' + error.message)
      }
    }
  }

  stop() {
    if (this.mediaRecorder && this.mediaRecorder.state !== 'inactive') {
      this.mediaRecorder.stop()
      this.isRecording = false
      this.updateUI('transcribing')
    }
  }

  async sendAudioForTranscription() {
    const mimeType = this.currentMimeType || 'audio/webm'
    const extension = this.getFileExtension(mimeType)
    const audioBlob = new Blob(this.audioChunks, { type: mimeType })

    const formData = new FormData()
    formData.append('audio', audioBlob, `recording.${extension}`)

    try {
      const response = await fetch('/transcribe', {
        method: 'POST',
        body: formData,
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        }
      })

      if (!response.ok) {
        throw new Error('Transcription failed')
      }

      const data = await response.json()

      if (data.text && this.hasInputTarget) {
        const currentValue = this.inputTarget.value
        const needsSpace = currentValue && !currentValue.endsWith(' ') && !currentValue.endsWith('\n')
        this.inputTarget.value = currentValue + (needsSpace ? ' ' : '') + data.text

        // Adjust textarea height
        this.inputTarget.style.height = 'auto'
        this.inputTarget.style.height = this.inputTarget.scrollHeight + 'px'
      }

      this.updateUI('idle')

    } catch (error) {
      console.error('Transcription error:', error)
      this.showError('Erreur de transcription')
      this.updateUI('idle')
    }
  }

  updateUI(state) {
    if (this.hasButtonTarget) {
      switch (state) {
        case 'recording':
          this.buttonTarget.classList.add('listening')
          this.buttonTarget.innerHTML = '<i class="bi bi-mic-fill"></i> Enregistrement...'
          break
        case 'transcribing':
          this.buttonTarget.classList.remove('listening')
          this.buttonTarget.classList.add('transcribing')
          this.buttonTarget.innerHTML = '<i class="bi bi-hourglass-split"></i> Transcription...'
          this.buttonTarget.disabled = true
          break
        case 'idle':
        default:
          this.buttonTarget.classList.remove('listening', 'transcribing')
          this.buttonTarget.innerHTML = '<i class="bi bi-mic"></i> Dicter mon reve'
          this.buttonTarget.disabled = false
          break
      }
    }

    if (this.hasStatusTarget) {
      if (state === 'recording') {
        this.statusTarget.textContent = 'Parlez maintenant...'
        this.statusTarget.style.display = 'block'
      } else {
        this.statusTarget.style.display = 'none'
      }
    }
  }

  showError(message) {
    if (this.hasStatusTarget) {
      this.statusTarget.textContent = message
      this.statusTarget.style.display = 'block'
      setTimeout(() => {
        this.statusTarget.style.display = 'none'
      }, 3000)
    }
  }

  disconnect() {
    if (this.mediaRecorder && this.mediaRecorder.state !== 'inactive') {
      this.mediaRecorder.stop()
    }
  }
}
