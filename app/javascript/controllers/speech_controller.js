import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "button", "status"]

  connect() {
    // Vérifier si l'API est supportée
    this.recognition = null
    this.isListening = false

    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition

    if (SpeechRecognition) {
      this.recognition = new SpeechRecognition()
      this.recognition.continuous = true
      this.recognition.interimResults = true
      this.recognition.lang = 'fr-FR'

      this.recognition.onresult = this.handleResult.bind(this)
      this.recognition.onerror = this.handleError.bind(this)
      this.recognition.onend = this.handleEnd.bind(this)
    } else {
      // Cacher le bouton si non supporté
      if (this.hasButtonTarget) {
        this.buttonTarget.style.display = 'none'
      }
    }
  }

  toggle() {
    if (!this.recognition) return

    if (this.isListening) {
      this.stop()
    } else {
      this.start()
    }
  }

  start() {
    if (!this.recognition) return

    this.isListening = true
    this.recognition.start()

    // Mettre à jour l'UI
    if (this.hasButtonTarget) {
      this.buttonTarget.classList.add('listening')
      this.buttonTarget.innerHTML = '<i class="bi bi-mic-fill"></i> Écoute en cours...'
    }
    if (this.hasStatusTarget) {
      this.statusTarget.textContent = '🎤 Parlez maintenant...'
      this.statusTarget.style.display = 'block'
    }
  }

  stop() {
    if (!this.recognition) return

    this.isListening = false
    this.recognition.stop()

    // Mettre à jour l'UI
    if (this.hasButtonTarget) {
      this.buttonTarget.classList.remove('listening')
      this.buttonTarget.innerHTML = '<i class="bi bi-mic"></i> Dicter mon rêve'
    }
    if (this.hasStatusTarget) {
      this.statusTarget.style.display = 'none'
    }
  }

  handleResult(event) {
    let finalTranscript = ''
    let interimTranscript = ''

    for (let i = event.resultIndex; i < event.results.length; i++) {
      const transcript = event.results[i][0].transcript
      if (event.results[i].isFinal) {
        finalTranscript += transcript
      } else {
        interimTranscript += transcript
      }
    }

    // Ajouter le texte final au textarea
    if (finalTranscript && this.hasInputTarget) {
      const currentValue = this.inputTarget.value
      const needsSpace = currentValue && !currentValue.endsWith(' ') && !currentValue.endsWith('\n')
      this.inputTarget.value = currentValue + (needsSpace ? ' ' : '') + finalTranscript

      // Ajuster la hauteur du textarea si nécessaire
      this.inputTarget.style.height = 'auto'
      this.inputTarget.style.height = this.inputTarget.scrollHeight + 'px'
    }

    // Afficher le texte interim
    if (this.hasStatusTarget && interimTranscript) {
      this.statusTarget.textContent = '🎤 ' + interimTranscript
    }
  }

  handleError(event) {
    console.error('Speech recognition error:', event.error)

    if (this.hasStatusTarget) {
      if (event.error === 'not-allowed') {
        this.statusTarget.textContent = '⚠️ Microphone non autorisé'
      } else {
        this.statusTarget.textContent = '⚠️ Erreur de reconnaissance'
      }
      setTimeout(() => {
        this.statusTarget.style.display = 'none'
      }, 3000)
    }

    this.stop()
  }

  handleEnd() {
    // Si on était en train d'écouter, redémarrer automatiquement
    if (this.isListening) {
      this.recognition.start()
    }
  }

  disconnect() {
    if (this.recognition && this.isListening) {
      this.recognition.stop()
    }
  }
}
