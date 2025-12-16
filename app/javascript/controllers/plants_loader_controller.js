import { Controller } from "@hotwired/stimulus"

// Loader plein écran déclenché par l'activité du turbo-frame #plants
export default class extends Controller {
  static targets = ["overlay"]

  connect() {
    this.show = this.show.bind(this)
    this.hide = this.hide.bind(this)

    // Événements Turbo spécifiques au frame
    this.element.addEventListener("turbo:before-fetch-request", this.show)
    this.element.addEventListener("turbo:before-fetch-response", this.hide)
    this.element.addEventListener("turbo:fetch-request-error", this.hide)
  }

  disconnect() {
    this.element.removeEventListener("turbo:before-fetch-request", this.show)
    this.element.removeEventListener("turbo:before-fetch-response", this.hide)
    this.element.removeEventListener("turbo:fetch-request-error", this.hide)
  }

  show() {
    if (this.hasOverlayTarget) {
      this.overlayTarget.style.display = "flex"
    }
  }

  hide() {
    if (this.hasOverlayTarget) {
      this.overlayTarget.style.display = "none"
    }
  }
}
