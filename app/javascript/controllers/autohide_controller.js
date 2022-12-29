import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="autohide"
export default class extends Controller {
    connect() {
        setTimeout(() => {
            this.dismiss();
        }, 2500);
    }

    dismiss() {
        this.element.remove();
    }
}
