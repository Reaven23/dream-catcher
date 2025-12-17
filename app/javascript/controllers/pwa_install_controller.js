import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["banner", "iosInstructions"]

  connect() {
    this.deferredPrompt = null

    // Check if already installed
    if (window.matchMedia('(display-mode: standalone)').matches) {
      return // Already running as PWA
    }

    // Check if user dismissed before (within last 7 days)
    const dismissed = localStorage.getItem('pwaInstallDismissed')
    if (dismissed && Date.now() - parseInt(dismissed) < 7 * 24 * 60 * 60 * 1000) {
      return
    }

    // Detect iOS Safari
    const isIOS = /iPad|iPhone|iPod/.test(navigator.userAgent) && !window.MSStream
    const isSafari = /^((?!chrome|android).)*safari/i.test(navigator.userAgent)

    if (isIOS && isSafari) {
      // Show iOS instructions after a short delay
      setTimeout(() => this.showIOSBanner(), 2000)
    } else {
      // Listen for beforeinstallprompt (Chrome, Edge, Samsung Internet, etc.)
      window.addEventListener('beforeinstallprompt', (e) => {
        e.preventDefault()
        this.deferredPrompt = e
        setTimeout(() => this.showBanner(), 2000)
      })
    }
  }

  showBanner() {
    if (this.hasBannerTarget) {
      this.bannerTarget.style.display = 'flex'
    }
  }

  showIOSBanner() {
    if (this.hasIosInstructionsTarget) {
      this.iosInstructionsTarget.style.display = 'flex'
    }
  }

  async install() {
    if (!this.deferredPrompt) return

    this.deferredPrompt.prompt()
    const { outcome } = await this.deferredPrompt.userChoice

    if (outcome === 'accepted') {
      console.log('PWA installed')
    }

    this.deferredPrompt = null
    this.dismiss()
  }

  dismiss() {
    if (this.hasBannerTarget) {
      this.bannerTarget.style.display = 'none'
    }
    if (this.hasIosInstructionsTarget) {
      this.iosInstructionsTarget.style.display = 'none'
    }
    localStorage.setItem('pwaInstallDismissed', Date.now().toString())
  }
}
