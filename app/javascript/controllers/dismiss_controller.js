import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="dismiss"
//
// Removes its element when the close button is clicked, or automatically after
// `data-dismiss-delay-value` milliseconds (when provided).
export default class extends Controller {
  static values = { delay: Number };

  connect() {
    if (this.delayValue > 0) {
      this.timeout = setTimeout(() => this.close(), this.delayValue);
    }
  }

  disconnect() {
    if (this.timeout) clearTimeout(this.timeout);
  }

  close() {
    this.element.remove();
  }
}
