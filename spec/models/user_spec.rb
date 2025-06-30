require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:todo_lists).dependent(:destroy) }
  end

  describe "devise modules" do
    it "includes database_authenticatable" do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it "includes registerable" do
      expect(User.devise_modules).to include(:registerable)
    end

    it "includes recoverable" do
      expect(User.devise_modules).to include(:recoverable)
    end

    it "includes rememberable" do
      expect(User.devise_modules).to include(:rememberable)
    end

    it "includes validatable" do
      expect(User.devise_modules).to include(:validatable)
    end
  end

  describe "validations" do
    it "is valid with valid attributes" do
      user = User.new(email: "test@example.com", password: "password")
      expect(user).to be_valid
    end

    it "is not valid without an email" do
      user = User.new(password: "password")
      expect(user).not_to be_valid
    end

    it "is not valid without a password" do
      user = User.new(email: "test@example.com")
      expect(user).not_to be_valid
    end
  end
end
