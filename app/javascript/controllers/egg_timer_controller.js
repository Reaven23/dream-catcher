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

    // Charger le son sauvegardé
    const savedAudioPath = localStorage.getItem('eggTimerAudioPath')
    if (savedAudioPath && this.hasAudioSelectTarget) {
      this.audioSelectTarget.value = savedAudioPath
      this.loadAudio(savedAudioPath)
    }
  }

  disconnect() {
    this.stopTimer()
  }

  start() {
    const selectedType = this.selectTarget.value
    if (!selectedType) {
      alert("Veuillez choisir un type d'œuf !")
      return
    }

    const durations = {
      "soft": 210,    // 3min30 (œuf à la coque)
      "medium": 300, // 5min (œuf mollet)
      "hard": 480,   // 8min (œuf dur)
      "poached": 240 // 4min (œuf poché)
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
    const formatted = `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`

    this.displayTarget.textContent = formatted

    // Barre de progression
    if (this.hasProgressTarget) {
      const progress = ((this.durationValue - this.remainingTime) / this.durationValue) * 100
      this.progressTarget.style.width = `${progress}%`
    }
  }

  complete() {
    this.stopTimer()
    this.runningValue = false
    this.playAlarm()
    this.showNotification()
    this.enableControls()
  }

  loadAudio(path) {
    // Libérer l'ancien audio
    if (this.customAudio) {
      this.customAudio.pause()
      this.customAudio = null
    }

    // Si pas de path (son par défaut), on ne charge rien
    if (!path || path === '') {
      this.audioPath = null
      return
    }

    // Charger le son depuis le chemin
    this.audioPath = path
    this.customAudio = new Audio(path)
    this.customAudio.volume = 0.7

    // Précharger le son
    this.customAudio.load()

    // Sauvegarder le choix
    localStorage.setItem('eggTimerAudioPath', path)
  }

  handleAudioChange(event) {
    const selectedPath = event.target.value
    this.loadAudio(selectedPath)
  }

  playAlarm() {
    // Utiliser le son personnalisé s'il existe
    if (this.customAudio) {
      this.customAudio.currentTime = 0
      this.customAudio.play().catch(e => {
        console.log("Impossible de jouer le son personnalisé, utilisation du son par défaut")
        this.playDefaultAlarm()
      })
      return
    }

    // Sinon, utiliser le son par défaut
    this.playDefaultAlarm()
  }

  playDefaultAlarm() {
    // Créer un son d'alarme simple
    try {
      this.audioContext = new (window.AudioContext || window.webkitAudioContext)()
      const oscillator = this.audioContext.createOscillator()
      const gainNode = this.audioContext.createGain()

      oscillator.connect(gainNode)
      gainNode.connect(this.audioContext.destination)

      oscillator.frequency.value = 800
      oscillator.type = 'sine'

      gainNode.gain.setValueAtTime(0.3, this.audioContext.currentTime)
      gainNode.gain.exponentialRampToValueAtTime(0.01, this.audioContext.currentTime + 0.5)

      oscillator.start(this.audioContext.currentTime)
      oscillator.stop(this.audioContext.currentTime + 0.5)

      // Répéter 3 fois
      setTimeout(() => {
        const osc2 = this.audioContext.createOscillator()
        const gain2 = this.audioContext.createGain()
        osc2.connect(gain2)
        gain2.connect(this.audioContext.destination)
        osc2.frequency.value = 800
        osc2.type = 'sine'
        gain2.gain.setValueAtTime(0.3, this.audioContext.currentTime)
        gain2.gain.exponentialRampToValueAtTime(0.01, this.audioContext.currentTime + 0.5)
        osc2.start(this.audioContext.currentTime)
        osc2.stop(this.audioContext.currentTime + 0.5)
      }, 600)

      setTimeout(() => {
        const osc3 = this.audioContext.createOscillator()
        const gain3 = this.audioContext.createGain()
        osc3.connect(gain3)
        gain3.connect(this.audioContext.destination)
        osc3.frequency.value = 800
        osc3.type = 'sine'
        gain3.gain.setValueAtTime(0.3, this.audioContext.currentTime)
        gain3.gain.exponentialRampToValueAtTime(0.01, this.audioContext.currentTime + 0.5)
        osc3.start(this.audioContext.currentTime)
        osc3.stop(this.audioContext.currentTime + 0.5)
      }, 1200)
    } catch (e) {
      console.log("Audio non disponible")
    }
  }

  showNotification() {
    // Notification visuelle
    const notification = document.createElement('div')
    notification.className = 'egg-timer-notification'
    notification.innerHTML = `
      <div class="egg-timer-notification-content">
        <i class="bi bi-egg-fried"></i>
        <h3>Votre œuf est prêt ! 🥚</h3>
        <p>Bon appétit !</p>
      </div>
    `
    document.body.appendChild(notification)

    setTimeout(() => {
      notification.classList.add('show')
    }, 100)

    setTimeout(() => {
      notification.classList.remove('show')
      setTimeout(() => notification.remove(), 300)
    }, 3000)
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
