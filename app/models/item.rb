class Item < ApplicationRecord
  belongs_to :todo_list

  enum status: { to_do: 0, in_progress: 1, done: 2 }

  validates :title, presence: true
  validates :status, presence: true
end
