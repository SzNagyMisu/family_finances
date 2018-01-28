class CreateFinancesExpenseCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :finances_expense_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
