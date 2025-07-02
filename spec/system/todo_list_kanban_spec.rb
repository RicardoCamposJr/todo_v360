# spec/system/todo_list_kanban_spec.rb

require 'rails_helper'

RSpec.describe "TodoLists Kanban view", type: :system do
  before do
    driven_by(:rack_test) # use :selenium_chrome_headless se quiser testar JS interativo

    @user = User.create!(email: "test@example.com", password: "password")
    login_as(@user, scope: :user)

    @todo_list = @user.todo_lists.create!(title: "Kanban Test List")
    @todo_list.items.create!(title: "Task To Do", status: :to_do)
    @todo_list.items.create!(title: "Task In Progress", status: :in_progress)
    @todo_list.items.create!(title: "Task Done", status: :done)
  end

  it "shows kanban columns with correct tasks" do
  visit todo_list_path(@todo_list, view: "kanban")

  expect(page).to have_content("Kanban Test List")

  within(".kanban-board") do
    columns = all(".kanban-column")

    within(columns[0]) do
      expect(page).to have_content("A Fazer")
      expect(page).to have_content("Task To Do")
    end

    within(columns[1]) do
      expect(page).to have_content("Em Progresso")
      expect(page).to have_content("Task In Progress")
    end

    within(columns[2]) do
      expect(page).to have_content("Concluídas")
      expect(page).to have_content("Task Done")
    end
  end
end

  it "shows new task button only in kanban view" do
    visit todo_list_path(@todo_list, view: "kanban")

    expect(page).to have_link("Nova Tarefa", href: new_todo_list_item_path(@todo_list))

    visit todo_list_path(@todo_list, view: "list")

    expect(page).not_to have_link("Nova Tarefa")
  end

  it "creates a new task from kanban view" do
    visit todo_list_path(@todo_list, view: "kanban")

    click_link "Nova Tarefa"

    expect(current_path).to eq(new_todo_list_item_path(@todo_list))

    fill_in "Título", with: "New Kanban Task"
    select "A Fazer", from: "Status"
    click_button "Salvar tarefa"

    expect(page).to have_content("New Kanban Task")
  end
end
