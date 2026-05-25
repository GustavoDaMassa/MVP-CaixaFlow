import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle() {
    this.element.classList.toggle("topnav--open")
  }

  close() {
    this.element.classList.remove("topnav--open")
  }
}
