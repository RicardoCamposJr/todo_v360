import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const savedView = localStorage.getItem("selectedView");
    const url = new URL(window.location);
    if (!url.searchParams.get("view") && savedView) {
      url.searchParams.set("view", savedView);
      window.location.replace(url.toString());
    }
  }

  setView(event) {
    const viewType = event.target.value;
    localStorage.setItem("selectedView", viewType);
    const url = new URL(window.location);
    url.searchParams.set("view", viewType);
    window.location.href = url.toString();
  }
}
