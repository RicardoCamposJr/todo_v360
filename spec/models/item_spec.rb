require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "associations" do
    it { should belong_to(:todo_list) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:status) }

    it "is valid with valid attributes" do
      user = User.create(email: "test@example.com", password: "password")
      todo_list = user.todo_lists.create(title: "My List")
      item = Item.new(title: "Test Item", status: :to_do, todo_list: todo_list)
      expect(item).to be_valid
    end

    it "is not valid without a title" do
      user = User.create(email: "test@example.com", password: "password")
      todo_list = user.todo_lists.create(title: "My List")
      item = Item.new(status: :to_do, todo_list: todo_list)
      expect(item).not_to be_valid
    end

    it "is not valid without a status" do
      user = User.create(email: "test@example.com", password: "password")
      todo_list = user.todo_lists.create(title: "My List")
      item = Item.new(title: "Test Item", todo_list: todo_list)
      expect(item).not_to be_valid
    end
  end

  describe "enums" do
    it "defines the correct statuses" do
      expect(Item.statuses.keys).to contain_exactly("to_do", "in_progress", "done")
    end
  end
end
