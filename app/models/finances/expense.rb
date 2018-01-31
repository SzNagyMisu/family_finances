module Finances
  class Expense < ApplicationRecord
    belongs_to :category, class_name: 'ExpenseCategory'

    validates :category_id, presence: true
    validates :amount,      presence: true,
                            numericality: true,
                            inclusion: 0..2147483647
    validates :title,       presence: true,
                            length: { maximum: 255 }
    validates :realized_on, presence: true


    scope :in_month, -> (year, month) { where realized_on: Date.new(year, month, 1)..Date.new(year, month, -1) }
  end
end
