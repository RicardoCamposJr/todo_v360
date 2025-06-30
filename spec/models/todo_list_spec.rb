require 'rails_helper'

RSpec.describe TodoList, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:items).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }

    it "is valid with valid attributes" do
      user = User.create(email: "test@example.com", password: "password")
      todo_list = TodoList.new(title: "My List", user: user)
      expect(todo_list).to be_valid
    end

    it "is not valid without a title" do
      user = User.create(email: "test@example.com", password: "password")
      todo_list = TodoList.new(user: user)
      expect(todo_list).not_to be_valid
    end
  end
end
