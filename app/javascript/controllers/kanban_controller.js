import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  // Define os targets (elementos filhos) que este controlador pode referenciar
  static targets = ["column", "card"];

  connect() {}

  // Função que é executada quando o usuário inicia o arrastar de um card
  dragStart(event) {
    // Captura o id da tarefa pelo atributo data-item-id do card
    const itemId = event.target.dataset.itemId;

    // Captura o id da todolist pelo atributo data-todo-list-id do card
    const todoListId = event.target.dataset.todoListId;

    // Define os dados que serão transferidos durante o drag and drop
    // Formato texto simples para compatibilidade básica
    event.dataTransfer.setData("text/plain", itemId);

    // Formato JSON para transferir dados mais complexos
    event.dataTransfer.setData(
      "application/json",
      JSON.stringify({
        itemId: itemId,
        todoListId: todoListId,
      })
    );

    // Armazena o card para ser utilizado depois
    this.draggedElement = event.target;

    // Adicionando estilos no card durante o arraste
    event.target.classList.add("dragging");
  }

  // Função executada quando o usuário termina de arrastar o card
  dragEnd(event) {
    // Removendo a estilização de arraste
    if (this.draggedElement) {
      this.draggedElement.classList.remove("dragging");
    }

    // Limpa o card da referência
    this.draggedElement = null;
  }

  // Função executada o card passa por uma coluna
  dragOver(event) {
    // Previne o comportamento padrão para permitir o drop
    event.preventDefault();

    // Define o efeito visual como "move" (cursor de mover)
    event.dataTransfer.dropEffect = "move";

    // Estilizando a coluna que o card está
    event.currentTarget.classList.add("drag-over");
  }

  // Função executada quando o card sai de uma coluna durante o arraste
  dragLeave(event) {
    // Remove a classe de destaque da coluna
    event.currentTarget.classList.remove("drag-over");
  }

  // Função executada quando o card é solto em uma coluna
  drop(event) {
    // Previne o comportamento padrão do navegador
    event.preventDefault();

    // Remove a classe de destaque da coluna
    event.currentTarget.classList.remove("drag-over");

    let itemId, todoListId;

    try {
      // Tenta recuperar os dados no formato JSON primeiro
      const jsonData = event.dataTransfer.getData("application/json");
      if (jsonData) {
        const data = JSON.parse(jsonData);
        itemId = data.itemId;
        todoListId = data.todoListId;
      }
    } catch (e) {
      // Se falhar, usa o método de fallback (texto simples)
      itemId = event.dataTransfer.getData("text/plain");
      if (this.draggedElement) {
        todoListId = this.draggedElement.dataset.todoListId;
      }
    }

    if (!itemId || !todoListId) {
      return;
    }

    // Obtém o novo status baseado no atributo data-status da coluna final
    const newStatus = event.currentTarget.dataset.status;
    const currentCard = this.draggedElement;

    // Movendo o card para a nova coluna
    if (currentCard && event.currentTarget) {
      // Remove mensagem de "coluna vazia" se existir
      const emptyMessage = event.currentTarget.querySelector(".empty-column");
      if (emptyMessage) {
        emptyMessage.remove();
      }

      // Move o card para a nova coluna
      event.currentTarget.appendChild(currentCard);

      // Atualiza a aparência visual do card baseado no novo status
      this.updateCardAppearance(currentCard, newStatus);
    }

    // Envia a atualização para o servidor
    this.updateItemStatus(todoListId, itemId, newStatus);
  }

  // Atualiza a aparência visual do card baseado no status
  updateCardAppearance(card, status) {
    // Seleciona elementos específicos do card
    const title = card.querySelector(".task-title");
    const description = card.querySelector(".task-description-kanban");

    // Remove estilos de tarefa concluída
    card.classList.remove("completed");
    if (title) title.classList.remove("text-decoration-line-through");
    if (description) description.classList.remove("text-muted");

    // Adiciona estilos de tarefa concluída se o status for "done"
    if (status === "done") {
      card.classList.add("completed");
      if (title) title.classList.add("text-decoration-line-through");
      if (description) description.classList.add("text-muted");
    }
  }

  // Envia requisição AJAX para atualizar o status da tarefa no servidor
  updateItemStatus(todoListId, itemId, newStatus) {
    fetch(`/todo_lists/${todoListId}/items/${itemId}/update_status`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        // Token CSRF para segurança (previne ataques CSRF)
        "X-CSRF-Token": document
          .querySelector("meta[name='csrf-token']")
          .getAttribute("content"),
      },
      // Envia o novo status no corpo da requisição
      body: JSON.stringify({ status: newStatus }),
    })
      .then((response) => {
        // Verificando se a responsta é positiva
        if (!response.ok) {
          throw new Error(`Erro de requisição! status: ${response.status}`);
        }
        return response.json();
      })
      .then((data) => {
        // Se a atualização foi positiva, atualiza os contadores das colunas
        this.updateColumnCounters();
      })
      .catch((error) => {
        // Em caso de erro, exibe alerta e recarrega a página
        alert(
          "Falha ao atualizar status da tarefa. A página será recarregada."
        );
        window.location.reload();
      });
  }

  // Atualiza os contadores de cards em cada coluna do kanban
  updateColumnCounters() {
    this.columnTargets.forEach((column) => {
      // Contando quantos cards existem na coluna
      const cards = column.querySelectorAll(".kanban-card");

      // Encontra o elemento badge do cabeçalho da coluna
      const header = column
        .closest(".kanban-column")
        .querySelector(".kanban-header .badge");

      // Atualiza o texto do badge com a quantidade de cards
      if (header) {
        header.textContent = cards.length;
      }
    });
  }
}
