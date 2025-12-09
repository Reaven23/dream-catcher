import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "button"]

  connect() {
    if (this.hasButtonTarget) {
      this.originalButtonText = this.buttonTarget.innerHTML
    }

    // Écouter les événements Turbo pour cacher le loader après navigation
    this.boundStop = this.stop.bind(this)
    document.addEventListener("turbo:before-render", this.boundStop)
    document.addEventListener("turbo:load", this.boundStop)
  }

  disconnect() {
    document.removeEventListener("turbo:before-render", this.boundStop)
    document.removeEventListener("turbo:load", this.boundStop)
  }

  // Appelé via data-action="click->loading#start" sur le bouton submit
  start(event) {
    // Afficher l'overlay
    if (this.hasOverlayTarget) {
      this.overlayTarget.style.display = "flex"
    }

    // Désactiver et changer le texte du bouton
    if (this.hasButtonTarget) {
      this.buttonTarget.disabled = true
      this.buttonTarget.innerHTML = '<i class="bi bi-hourglass-split"></i> Analyse en cours...'
    }
  }

  stop() {
    if (this.hasOverlayTarget) {
      this.overlayTarget.style.display = "none"
    }
    if (this.hasButtonTarget) {
      this.buttonTarget.disabled = false
      this.buttonTarget.innerHTML = this.originalButtonText || 'Analyser mon rêve'
    }
  }
};
