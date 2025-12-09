import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

// Locale française
const frenchLocale = {
  firstDayOfWeek: 1,
  weekdays: {
    shorthand: ["Dim", "Lun", "Mar", "Mer", "Jeu", "Ven", "Sam"],
    longhand: ["Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"]
  },
  months: {
    shorthand: ["Jan", "Fév", "Mar", "Avr", "Mai", "Juin", "Juil", "Aoû", "Sep", "Oct", "Nov", "Déc"],
    longhand: ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"]
  }
}

flatpickr.localize(frenchLocale)

export default class extends Controller {
  static values = {
    dateFormat: { type: String, default: "d/m/Y" },
    defaultDate: { type: String, default: null },
    maxDate: { type: String, default: "today" }
  }

  connect() {
    const options = {
      dateFormat: this.dateFormatValue,
      allowInput: true,
      clickOpens: true,
      maxDate: this.maxDateValue === "today" ? "today" : this.maxDateValue,
      defaultDate: this.defaultDateValue || "today"
    }

    this.flatpickr = flatpickr(this.element, options)
  }

  disconnect() {
    if (this.flatpickr) {
      this.flatpickr.destroy()
    }
  }
};
