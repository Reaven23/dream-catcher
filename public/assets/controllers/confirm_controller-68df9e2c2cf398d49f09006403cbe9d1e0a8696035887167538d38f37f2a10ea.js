import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.modal = document.getElementById('confirm-modal')
    this.boundKeydown = this.handleKeydown.bind(this)
  }

  open(event) {
    event.preventDefault()
    event.stopPropagation()

    if (!this.modal) return

    // Récupérer les données de l'élément déclencheur
    const trigger = event.currentTarget
    this.pendingForm = trigger.closest('form')

    // Mettre à jour le contenu de la modale
    const title = trigger.dataset.confirmTitle || "Confirmation"
    const message = trigger.dataset.confirmMessage || "Êtes-vous sûr ?"
    const confirmText = trigger.dataset.confirmText || "Confirmer"
    const cancelText = trigger.dataset.cancelText || "Annuler"
    const type = trigger.dataset.confirmType || "danger"

    this.modal.querySelector('.confirm-title').textContent = title
    this.modal.querySelector('.confirm-message').innerHTML = message
    this.modal.querySelector('.btn-confirm').textContent = confirmText
    this.modal.querySelector('.btn-cancel').textContent = cancelText

    // Appliquer le type (danger, warning, etc.)
    const confirmBtn = this.modal.querySelector('.btn-confirm')
    confirmBtn.className = `btn btn-confirm btn-${type}`

    // Afficher la modale
    this.modal.classList.add('is-open')
    document.body.style.overflow = 'hidden'
    document.addEventListener('keydown', this.boundKeydown)
  }

  close() {
    if (!this.modal) return

    this.modal.classList.remove('is-open')
    document.body.style.overflow = ''
    document.removeEventListener('keydown', this.boundKeydown)
    this.pendingForm = null
  }

  confirmAction() {
    if (this.pendingForm) {
      // Soumettre le formulaire
      this.pendingForm.requestSubmit()
    }
    this.close()
  }

  handleKeydown(event) {
    if (event.key === 'Escape') {
      this.close()
    }
  }

  closeOnOverlay(event) {
    if (event.target === this.modal) {
      this.close()
    }
  }
};
