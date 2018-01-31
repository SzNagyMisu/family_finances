module Finances
  class ExpenseCategory < ApplicationRecord
    has_many :expenses, foreign_key: 'category_id', dependent: :restrict_with_error

    validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
  end
end
