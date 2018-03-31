module Finances
  class Expense < ApplicationRecord
    belongs_to :category, class_name: 'ExpenseCategory'

    # validates :category_id, presence: true
    validates :amount,      presence: true,
                            numericality: -> { amount.present? },
                            inclusion: 0..2147483647
    validates :title,       presence: true,
                            length: { maximum: 255 }
    validates :realized_on, presence: true


    scope :in_month, -> (month) do
      case month.to_s
      when 'current'
        today = Date.today
        where realized_on: today.beginning_of_month..today.end_of_month
      when 'all'
        all
      when /\d{4}-\d{2}/
        year, month = month.split('-').map &:to_i
        where realized_on: Date.new(year, month, 1)..Date.new(year, month, -1)
      else
        raise ArgumentError, 'parameter `month` should be either "all" or "current" or month given in the format "yyyy-mm"'
      end
    end

    scope :statistics, -> { joins(:category).select("#{ExpenseCategory.sql_column :name} expense_category_name, SUM(#{sql_column :amount}) sum_amount").group(:category_id) }

    def category_name
      category.try :name
    end
  end
end
