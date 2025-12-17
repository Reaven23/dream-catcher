import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["banner", "iosInstructions"]

  connect() {
    this.deferredPrompt = null

    // Check if already installed
    if (window.matchMedia('(display-mode: standalone)').matches) {
      return // Already running as PWA
    }

    this.setupInstallPrompt()
    this.setupIOSPrompt()
  }

  setupInstallPrompt() {
    // Listen for the beforeinstallprompt event (Chrome, Edge, Samsung Internet, etc.)
    window.addEventListener('beforeinstallprompt', (event) => {
      // Prevent the default browser prompt
      event.preventDefault()
      // Store the event for later use
      this.deferredPrompt = event
      console.log('[PWA] Install prompt ready')

      // Only show on mobile devices and if not dismissed before
      if (this.isMobileDevice() && !this.wasPromptDismissed()) {
        setTimeout(() => this.showBanner(), 2000)
      }
    })

    // Listen for successful installation
    window.addEventListener('appinstalled', () => {
      console.log('[PWA] App installed successfully')
      this.hideBanner()
      this.deferredPrompt = null
    })
  }

  setupIOSPrompt() {
    // Detect iOS Safari
    const isIOS = /iPad|iPhone|iPod/.test(navigator.userAgent) && !window.MSStream
    const isSafari = /^((?!chrome|android).)*safari/i.test(navigator.userAgent)

    if (isIOS && isSafari && !this.wasPromptDismissed()) {
      setTimeout(() => this.showIOSBanner(), 2000)
    }
  }

  isMobileDevice() {
    return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ||
           (window.innerWidth <= 768)
  }

  wasPromptDismissed() {
    const dismissed = localStorage.getItem('pwa-install-dismissed')
    if (!dismissed) return false

    // Allow showing again after 7 days
    const dismissedDate = new Date(dismissed)
    const daysSinceDismissed = (Date.now() - dismissedDate.getTime()) / (1000 * 60 * 60 * 24)
    return daysSinceDismissed < 7
  }

  showBanner() {
    if (this.hasBannerTarget) {
      this.bannerTarget.style.display = 'flex'
    }
  }

  hideBanner() {
    if (this.hasBannerTarget) {
      this.bannerTarget.style.display = 'none'
    }
  }

  showIOSBanner() {
    if (this.hasIosInstructionsTarget) {
      this.iosInstructionsTarget.style.display = 'flex'
    }
  }

  hideIOSBanner() {
    if (this.hasIosInstructionsTarget) {
      this.iosInstructionsTarget.style.display = 'none'
    }
  }

  install() {
    if (!this.deferredPrompt) {
      console.log('[PWA] No install prompt available')
      return
    }

    // Show the browser's install prompt
    this.deferredPrompt.prompt()

    // Wait for user response
    this.deferredPrompt.userChoice.then((choiceResult) => {
      if (choiceResult.outcome === 'accepted') {
        console.log('[PWA] User accepted install')
      } else {
        console.log('[PWA] User dismissed install')
      }
      this.deferredPrompt = null
      this.hideBanner()
    })
  }

  dismiss() {
    localStorage.setItem('pwa-install-dismissed', new Date().toISOString())
    this.hideBanner()
    this.hideIOSBanner()
  }
}
