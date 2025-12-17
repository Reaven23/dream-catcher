import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "dialog"]

  connect() {
    // Afficher la modal automatiquement si elle doit être affichée
    if (this.element.dataset.showModal === "true") {
      // Petit délai pour que la page se charge
      setTimeout(() => {
        this.open()
      }, 500)
    }
  }

  open() {
    if (this.hasOverlayTarget) {
      this.overlayTarget.style.display = "flex"
      this.overlayTarget.style.opacity = "1"
      this.overlayTarget.style.visibility = "visible"
    }
    if (this.hasDialogTarget) {
      this.dialogTarget.style.transform = "scale(1) translateY(0)"
    }
    document.body.style.overflow = "hidden"
  }

  close() {
    if (this.hasOverlayTarget) {
      this.overlayTarget.style.opacity = "0"
      this.overlayTarget.style.visibility = "hidden"
      setTimeout(() => {
        this.overlayTarget.style.display = "none"
      }, 300)
    }
    if (this.hasDialogTarget) {
      this.dialogTarget.style.transform = "scale(0.9) translateY(20px)"
    }
    document.body.style.overflow = ""

    // Marquer dans la session que la modal a été vue
    this.markAsSeen()
  }

  closeOnOverlay(event) {
    // Fermer seulement si on clique sur l'overlay (pas sur le dialog)
    if (event.target === this.overlayTarget) {
      this.close()
    }
  }

  markAsSeen() {
    // Envoyer une requête au serveur pour marquer la modal comme vue dans la session
    fetch('/mark_christmas_modal_seen', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      credentials: 'same-origin'
    }).catch(err => console.error('Erreur lors de la sauvegarde:', err))
  }
}
