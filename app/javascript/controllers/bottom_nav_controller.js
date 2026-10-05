import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.lastScrollY = window.scrollY
    this.showTimer = null

    this.handleScroll = this.handleScroll.bind(this)

    window.addEventListener("scroll", this.handleScroll, { passive: true })
  }

  disconnect() {
    window.removeEventListener("scroll", this.handleScroll)

    if (this.showTimer) {
      clearTimeout(this.showTimer)
    }
  }

  handleScroll() {
    const currentScrollY = window.scrollY
    const difference = currentScrollY - this.lastScrollY

    if (Math.abs(difference) < 5) {
      return
    }

    if (difference > 0 && currentScrollY > 80) {
      this.hide()
    } else {
      this.show()
    }

    this.lastScrollY = currentScrollY

    clearTimeout(this.showTimer)

    this.showTimer = setTimeout(() => {
      this.show()
    }, 1500)
  }

  hide() {
    if (window.innerWidth >= 600) return

    this.element.classList.add("bottom-nav--hidden")
  }

  show() {
    this.element.classList.remove("bottom-nav--hidden")
  }
}
