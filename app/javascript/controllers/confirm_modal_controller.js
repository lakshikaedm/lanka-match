import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "dialog",
    "title",
    "message",
    "form",
    "method",
    "confirmButton"
  ]

  open(event) {
    const trigger = event.currentTarget

    this.titleTarget.textContent =
      trigger.dataset.confirmTitle || "Are you sure?"

    this.messageTarget.textContent =
      trigger.dataset.confirmMessage || ""

    this.confirmButtonTarget.textContent =
      trigger.dataset.confirmButton || "Confirm"

    this.formTarget.action = trigger.dataset.confirmAction

    const method = (trigger.dataset.confirmMethod || "post").toLowerCase()

    if (method === "post") {
      this.methodTarget.disabled = true
      this.methodTarget.value = ""
    } else {
      this.methodTarget.disabled = false
      this.methodTarget.value = method
    }

    this.dialogTarget.showModal()
  }

  close() {
    this.dialogTarget.close()
  }

  backdropClose(event) {
    if (event.target === this.dialogTarget) {
      this.close()
    }
  }
}
