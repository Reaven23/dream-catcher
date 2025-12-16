import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["labelText", "fileName"]

  updateLabel(event) {
    const input = event.target
    const file = input.files[0]

    if (file) {
      if (this.hasFileNameTarget) {
        this.fileNameTarget.textContent = file.name
        this.fileNameTarget.classList.add("has-file")
      }

      if (this.hasLabelTextTarget) {
        this.labelTextTarget.textContent = "Changer la photo"
      }
    } else {
      if (this.hasFileNameTarget) {
        this.fileNameTarget.textContent = ""
        this.fileNameTarget.classList.remove("has-file")
      }

      if (this.hasLabelTextTarget) {
        this.labelTextTarget.textContent = "Choisir une photo"
      }
    }
  }
}
