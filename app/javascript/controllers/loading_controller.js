import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["spinner", "overlay", "button"]

  connect() {
    // Sauvegarder le texte original du bouton
    if (this.hasButtonTarget) {
      this.originalButtonText = this.buttonTarget.innerHTML
    }

    // Écouter les événements Turbo pour gérer le loader
    this.element.addEventListener("turbo:submit-start", this.show.bind(this))
    this.element.addEventListener("turbo:submit-end", this.hide.bind(this))
  }

  disconnect() {
    this.element.removeEventListener("turbo:submit-start", this.show.bind(this))
    this.element.removeEventListener("turbo:submit-end", this.hide.bind(this))
  }

  show(event) {
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.remove("d-none")
    }
    if (this.hasSpinnerTarget) {
      this.spinnerTarget.classList.remove("d-none")
    }
    if (this.hasButtonTarget) {
      this.buttonTarget.disabled = true
      this.buttonTarget.innerHTML = '<i class="bi bi-hourglass-split"></i> Analyse en cours...'
    }
  }

  hide(event) {
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.add("d-none")
    }
    if (this.hasSpinnerTarget) {
      this.spinnerTarget.classList.add("d-none")
    }
    if (this.hasButtonTarget) {
      this.buttonTarget.disabled = false
      this.buttonTarget.innerHTML = this.originalButtonText || 'Analyser mon rêve'
    }
  }
}
