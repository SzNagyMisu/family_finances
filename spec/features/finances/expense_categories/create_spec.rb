require 'rails_helper'

module Finances
  RSpec.describe 'Creating new expense category', type: :feature, js: true do
    before :each do
      visit finances.new_expense_category_path
    end

    it 'saves a new expense category record in the database and redirects to the index page.' do
      expect(page).to have_selector 'h1', text: 'Új kiadás típus'

      expect(page).to have_selector 'label', text: 'Megnevezés'
      fill_in 'expense_category_name', with: 'Expense Category'

      expect { click_button 'Kiadás típus létrehozása' }.to change(ExpenseCategory, :count).by 1
      expect(ExpenseCategory.last.name).to eq 'Expense Category'
      expect(current_url).to match /#{finances.expense_categories_path}\z/
    end
  end
end
