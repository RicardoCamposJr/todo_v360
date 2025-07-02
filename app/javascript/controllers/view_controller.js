import { Controller } from "@hotwired/stimulus";

// Este controller atualiza os links de retorno para a view "show", inserindo a forma de visualização
// escolhida pelo usuário na URL, utilizando o valor armazenado em localStorage na chave "selectedView"
export default class extends Controller {
  // Target para os links que deverão realizar a inserção da escolha na URL
  // Por padrão, o Stimulus já cria this.backLinkTarget e this.hasBackLinkTarget
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
