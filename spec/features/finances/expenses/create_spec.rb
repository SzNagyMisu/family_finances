require 'rails_helper'

module Finances
  RSpec.describe 'Creating a new expense', type: :feature, js: true do
    let!(:category) { FactoryBot.create :finances_expense_category }

    before :each do
      visit finances.new_expense_path
    end

    it 'saves a new expense record in the database and redirects to the index page.' do
      expect(page).to have_selector 'h1', text: 'Kiadás felvétele'

      expect(page).to have_selector 'label', text: 'Kiadás típusa'
      expect(page).to have_selector 'label', text: 'Címke'
      expect(page).to have_selector 'label', text: 'Összeg'
      expect(page).to have_selector 'label', text: 'Időpont'

      select  category.name,         from: 'expense_category_id'
      fill_in 'expense_title',       with: 'teszt kiadás'
      fill_in 'expense_amount',      with: '10_000'
      fill_in 'expense_realized_on', with: Date.today.to_s

      expect { click_button 'Kiadás létrehozása' }.to change(Expense, :count).by 1
      expect(Expense.last.attributes.symbolize_keys).to include category_id: category.id,
                                                                title:       'teszt kiadás',
                                                                amount:      10_000,
                                                                realized_on: Date.today
      expect(current_url).to match /#{finances.expenses_path}\z/
    end

    context 'if invalid attributes given,' do
      it 'rerenders the :new page with the error messages.' do
        expect(page).to have_selector 'h1', text: 'Kiadás felvétele'

        fill_in 'expense_title',       with: 'x' * 256
        fill_in 'expense_realized_on', with: ''
        expect { click_button 'Kiadás létrehozása' }.to change(Expense, :count).by 0
        expect(page).to have_selector 'h1', text: 'Kiadás felvétele'
        expect(page).to have_field 'expense_title',       with: 'x' * 256
        expect(page).to have_field 'expense_amount',      with: ''
        expect(page).to have_field 'expense_realized_on', with: ''

        expect(page).to have_selector '#error_explanation', text: 'Kiadás típusa kötelező'
        expect(page).to have_selector '#error_explanation', text: 'Címke túl hosszú'
        expect(page).to have_selector '#error_explanation', text: 'Összeg nincs megadva'
        expect(page).to have_selector '#error_explanation', text: 'Időpont nincs megadva'
      end
    end
  end
end
