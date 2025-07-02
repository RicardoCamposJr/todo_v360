# spec/system/todo_lists_spec.rb

require 'rails_helper'

RSpec.describe "TodoLists index page", type: :system do
  before do
    @user = User.create!(email: "test@example.com", password: "password")
    login_as(@user, scope: :user)
  end

  it "shows empty state when no lists exist" do
    visit todo_lists_path
    expect(page).to have_content("Nenhuma lista criada ainda")
  end

  it "displays existing lists and tasks" do
    list = @user.todo_lists.create!(title: "Minha Lista")
    list.items.create!(title: "Tarefa 1", status: :to_do)

    visit todo_lists_path

    expect(page).to have_content("Minha Lista")
    expect(page).to have_content("Tarefa 1")
  end

  it "allows creating a new list from index page" do
    visit todo_lists_path
    click_link "Criar Primeira Lista"

    expect(current_path).to eq(new_todo_list_path)

    fill_in "Título", with: "Nova Lista"
    click_button "Salvar"

    expect(page).to have_content("Nova Lista")
  end

  it "allows viewing a specific list from index" do
    list = @user.todo_lists.create!(title: "Lista Visualizar")
    visit todo_lists_path

    click_link "Ver Lista", href: todo_list_path(list)

    expect(current_path).to eq(todo_list_path(list))
    expect(page).to have_content("Lista Visualizar")
  end

  it "allows editing a list from index" do
    list = @user.todo_lists.create!(title: "Lista Editar")
    visit todo_lists_path

    click_link "Editar", href: edit_todo_list_path(list)

    expect(current_path).to eq(edit_todo_list_path(list))
    fill_in "Título", with: "Lista Editada"
    click_button "Atualizar"

    expect(page).to have_content("Lista Editada")
  end

  it "allows deleting a list from index" do
    list = @user.todo_lists.create!(title: "Lista Excluir")
    visit todo_lists_path

    click_button "Excluir"

    expect(page).not_to have_content("Lista Excluir")
    expect(page).to have_content("Nenhuma lista criada ainda")
  end

  it "shows number of tasks and completed tasks correctly" do
    list = @user.todo_lists.create!(title: "Lista Contagem")
    list.items.create!(title: "Task 1", status: :done)
    list.items.create!(title: "Task 2", status: :to_do)

    visit todo_lists_path

    expect(page).to have_content("2 tarefas")
    expect(page).to have_content("1 concluída")
  end
end
