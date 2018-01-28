module Finances
  class Expense < ApplicationRecord
    belongs_to :category, class_name: 'ExpenseCategory'
  end
end
