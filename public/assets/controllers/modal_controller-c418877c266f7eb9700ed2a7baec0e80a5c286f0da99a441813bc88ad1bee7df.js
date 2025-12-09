import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "overlay"]

  connect() {
    // Fermer avec Escape
    this.boundKeydown = this.handleKeydown.bind(this)
    document.addEventListener("keydown", this.boundKeydown)
  }

  disconnect() {
    document.removeEventListener("keydown", this.boundKeydown)
    this.enableScroll()
  }

  open(event) {
    event.preventDefault()
    this.element.classList.add("is-open")
    this.disableScroll()

    // Focus sur le premier input
    setTimeout(() => {
      const firstInput = this.dialogTarget.querySelector("input, textarea")
      if (firstInput) firstInput.focus()
    }, 100)
  }

  close(event) {
    if (event) event.preventDefault()
    this.element.classList.remove("is-open")
    this.enableScroll()
  }

  closeOnOverlay(event) {
    // Fermer seulement si on clique sur l'overlay (pas sur le dialog)
    if (event.target === this.overlayTarget) {
      this.close(event)
    }
  }

  handleKeydown(event) {
    if (event.key === "Escape" && this.element.classList.contains("is-open")) {
      this.close()
    }
  }

  disableScroll() {
    document.body.style.overflow = "hidden"
  }

  enableScroll() {
    document.body.style.overflow = ""
  }
};
