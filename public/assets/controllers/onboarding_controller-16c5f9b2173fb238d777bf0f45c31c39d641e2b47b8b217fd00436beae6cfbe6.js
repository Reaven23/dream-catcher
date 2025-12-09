import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["step", "progress", "progressText", "prevBtn", "nextBtn", "submitBtn"]
  static values = { currentStep: { type: Number, default: 0 } }

  connect() {
    this.totalSteps = this.stepTargets.length
    this.showStep(this.currentStepValue)
  }

  next() {
    if (this.validateCurrentStep()) {
      if (this.currentStepValue < this.totalSteps - 1) {
        this.currentStepValue++
        this.showStep(this.currentStepValue)
      }
    }
  }

  prev() {
    if (this.currentStepValue > 0) {
      this.currentStepValue--
      this.showStep(this.currentStepValue)
    }
  }

  goToStep(event) {
    const stepIndex = parseInt(event.currentTarget.dataset.stepIndex)
    if (stepIndex <= this.currentStepValue) {
      this.currentStepValue = stepIndex
      this.showStep(this.currentStepValue)
    }
  }

  showStep(index) {
    // Cacher toutes les étapes
    this.stepTargets.forEach((step, i) => {
      step.classList.toggle('active', i === index)
      step.classList.toggle('d-none', i !== index)
    })

    // Mettre à jour la barre de progression
    const progress = ((index + 1) / this.totalSteps) * 100
    if (this.hasProgressTarget) {
      this.progressTarget.style.width = `${progress}%`
    }
    if (this.hasProgressTextTarget) {
      this.progressTextTarget.textContent = `Étape ${index + 1} sur ${this.totalSteps}`
    }

    // Gérer les boutons
    if (this.hasPrevBtnTarget) {
      this.prevBtnTarget.classList.toggle('d-none', index === 0)
    }
    if (this.hasNextBtnTarget) {
      this.nextBtnTarget.classList.toggle('d-none', index === this.totalSteps - 1)
    }
    if (this.hasSubmitBtnTarget) {
      this.submitBtnTarget.classList.toggle('d-none', index !== this.totalSteps - 1)
    }

    // Animation d'entrée
    const activeStep = this.stepTargets[index]
    activeStep.style.animation = 'none'
    activeStep.offsetHeight // Trigger reflow
    activeStep.style.animation = 'fadeInUp 0.5s ease forwards'
  }

  validateCurrentStep() {
    const currentStepElement = this.stepTargets[this.currentStepValue]
    const requiredFields = currentStepElement.querySelectorAll('[required]')
    let isValid = true

    requiredFields.forEach(field => {
      if (!field.value.trim()) {
        isValid = false
        field.classList.add('is-invalid')
        this.shakeElement(field)
      } else {
        field.classList.remove('is-invalid')
      }
    })

    return isValid
  }

  shakeElement(element) {
    element.style.animation = 'shake 0.5s ease'
    setTimeout(() => {
      element.style.animation = ''
    }, 500)
  }

  selectOption(event) {
    const container = event.currentTarget.closest('.options-container')
    const isMultiple = container.dataset.multiple === 'true'
    const input = container.querySelector('input[type="hidden"]')
    const option = event.currentTarget

    if (isMultiple) {
      // Sélection multiple
      option.classList.toggle('selected')
      const selectedOptions = container.querySelectorAll('.option-btn.selected')
      const values = Array.from(selectedOptions).map(opt => opt.dataset.value)
      input.value = JSON.stringify(values)
    } else {
      // Sélection simple
      container.querySelectorAll('.option-btn').forEach(opt => opt.classList.remove('selected'))
      option.classList.add('selected')
      input.value = option.dataset.value
    }
  }
};
