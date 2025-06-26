class Item < ApplicationRecord
  belongs_to :todo_list

  validates :title, presence: true
  validates :status, presence: true
end
