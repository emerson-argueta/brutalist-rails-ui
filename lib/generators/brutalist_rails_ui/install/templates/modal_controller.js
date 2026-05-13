import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  closeOnBackdrop(event) {
    if (this.hasPanelTarget && !this.panelTarget.contains(event.target)) {
      this.close()
    }
  }

  close() {
    const frame = this.element.closest("turbo-frame")
    if (frame) frame.innerHTML = ""
  }
}
