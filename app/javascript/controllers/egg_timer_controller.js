import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "button", "select", "progress", "audioSelect"]
  static values = {
    duration: Number,
    running: Boolean
  }

  connect() {
    this.remainingTime = 0
    this.interval = null
    this.audioContext = null
    this.customAudio = null
    this.audioPath = null
    this.alarmInterval = null
    this.modalElement = null
    this.modalClickHandler = null

    const savedAudioPath = localStorage.getItem('eggTimerAudioPath')
    if (savedAudioPath && this.hasAudioSelectTarget) {
      this.audioSelectTarget.value = savedAudioPath
      this.loadAudio(savedAudioPath)
    }
  }

  disconnect() {
    this.stopTimer()
    this.stopAlarm()
    this.removeModal()
  }

  start() {
    const selectedType = this.selectTarget.value
    if (!selectedType) {
      alert("Veuillez choisir un type d'œuf !")
      return
    }

    const durations = {
      "soft": 5,
      "medium": 300,
      "hard": 480,
      "poached": 240
    }

    this.remainingTime = durations[selectedType] || 0
    this.durationValue = this.remainingTime
    this.runningValue = true

    this.updateDisplay()
    this.startTimer()
    this.disableControls()
  }

  stop() {
    this.stopTimer()
    this.stopAlarm()
    this.removeModal()
    this.runningValue = false
    this.remainingTime = 0
    this.updateDisplay()
    this.enableControls()
  }

  startTimer() {
    this.interval = setInterval(() => {
      this.remainingTime--
      this.updateDisplay()
      if (this.remainingTime <= 0) {
        this.complete()
      }
    }, 1000)
  }

  stopTimer() {
    if (this.interval) {
      clearInterval(this.interval)
      this.interval = null
    }
  }

  updateDisplay() {
    const minutes = Math.floor(this.remainingTime / 60)
    const seconds = this.remainingTime % 60
    this.displayTarget.textContent = `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`

    if (this.hasProgressTarget) {
      const progress = ((this.durationValue - this.remainingTime) / this.durationValue) * 100
      this.progressTarget.style.width = `${progress}%`
    }
  }

  complete() {
    this.stopTimer()
    this.runningValue = false
    this.playAlarm()
    this.showModal()
    this.enableControls()
  }

  loadAudio(path) {
    if (this.customAudio) {
      this.customAudio.pause()
      this.customAudio = null
    }

    if (!path || path === '') {
      this.audioPath = null
      return
    }

    this.audioPath = path
    this.customAudio = new Audio(path)
    this.customAudio.volume = 0.7
    this.customAudio.load()
    localStorage.setItem('eggTimerAudioPath', path)
  }

  handleAudioChange(event) {
    this.loadAudio(event.target.value)
  }

  playAlarm() {
    if (this.customAudio) {
      this.customAudio.loop = true
      this.customAudio.currentTime = 0
      this.customAudio.play().catch(() => this.playDefaultAlarm())
      return
    }
    this.playDefaultAlarm()
  }

  stopAlarm() {
    if (this.alarmInterval) {
      clearInterval(this.alarmInterval)
      this.alarmInterval = null
    }

    if (this.customAudio) {
      this.customAudio.pause()
      this.customAudio.currentTime = 0
      this.customAudio.loop = false
    }

    if (this.audioContext) {
      try { this.audioContext.close() } catch (e) {}
      this.audioContext = null
    }
  }

  playDefaultAlarm() {
    try {
      this.audioContext = new (window.AudioContext || window.webkitAudioContext)()
    } catch (e) {
      return
    }

    const beep = () => {
      if (!this.audioContext || this.audioContext.state === 'closed') return
      try {
        const osc = this.audioContext.createOscillator()
        const gain = this.audioContext.createGain()
        osc.connect(gain)
        gain.connect(this.audioContext.destination)
        osc.frequency.value = 800
        osc.type = 'sine'
        gain.gain.setValueAtTime(0.3, this.audioContext.currentTime)
        gain.gain.exponentialRampToValueAtTime(0.01, this.audioContext.currentTime + 0.5)
        osc.start(this.audioContext.currentTime)
        osc.stop(this.audioContext.currentTime + 0.5)
      } catch (e) {}
    }

    beep()
    this.alarmInterval = setInterval(beep, 1500)
  }

  showModal() {
    this.removeModal()

    const modal = document.createElement('div')
    modal.className = 'egg-timer-modal-overlay show'
    modal.innerHTML = `
      <div class="egg-timer-modal-dialog">
        <div class="egg-timer-modal-content">
          <i class="bi bi-egg-fried"></i>
          <h3>Ton œuf est prêt ma belle! 🥚</h3>
          <p>Bon appétit !</p>
          <button type="button" class="btn btn-mystic egg-timer-modal-close">
            Fermer
          </button>
        </div>
      </div>
    `

    this.modalClickHandler = (e) => {
      if (e.target.classList.contains('egg-timer-modal-close') || e.target.classList.contains('egg-timer-modal-overlay')) {
        this.closeModal()
      }
    }

    modal.addEventListener('click', this.modalClickHandler)
    document.body.appendChild(modal)
    this.modalElement = modal
  }

  removeModal() {
    if (this.modalElement) {
      if (this.modalClickHandler) {
        this.modalElement.removeEventListener('click', this.modalClickHandler)
        this.modalClickHandler = null
      }
      if (this.modalElement.parentNode) {
        this.modalElement.parentNode.removeChild(this.modalElement)
      }
      this.modalElement = null
    }
  }

  closeModal() {
    this.stopAlarm()
    this.removeModal()
  }

  disableControls() {
    this.selectTarget.disabled = true
    this.buttonTargets.forEach(btn => {
      if (btn.dataset.action === 'click->egg-timer#start') {
        btn.disabled = true
        btn.classList.add('disabled')
      }
    })
  }

  enableControls() {
    this.selectTarget.disabled = false
    this.buttonTargets.forEach(btn => {
      btn.disabled = false
      btn.classList.remove('disabled')
    })
  }
}
