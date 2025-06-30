import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["backLink"];

  connect() {
    const savedView = localStorage.getItem("selectedView");

    if (savedView && this.hasBackLinkTarget) {
      const url = new URL(this.backLinkTarget.href);
      url.searchParams.set("view", savedView);
      this.backLinkTarget.href = url.toString();
    }
  }
}
