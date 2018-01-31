class CreateFinancesExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :finances_expenses do |t|
      t.references :category,    null: false, foreign_key: { to_table: :finances_expense_categories }
      t.string     :title,       null: false
      t.integer    :amount,      null: false
      t.date       :realized_on, null: false

      t.timestamps
    end
  end
end
