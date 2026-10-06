import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    autoDismiss: Boolean
  }

  connect() {
    if (this.autoDismissValue) {
      this.timeout = setTimeout(() => {
        this.dismiss()
      }, 3000)
    }
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  dismiss() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }

    this.element.classList.add("flash-message--hiding")

    this.element.addEventListener(
      "transitionend",
      () => {
        this.element.remove()
      },
      { once: true }
    )
  }
}
