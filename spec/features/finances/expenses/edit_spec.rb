require 'rails_helper'

# module Finances
  RSpec.describe 'Editing an expense', type: :feature, js: true do
    let!(:first_category)  { FactoryBot.create :finances_expense_category, name: 'First Category' }
    let!(:second_category) { FactoryBot.create :finances_expense_category, name: 'Second Category' }
    let!(:expense)         { FactoryBot.create :finances_expense, category: first_category, title: 'first title', amount: 100, realized_on: Date.yesterday }

    before :each do
      visit finances.edit_expense_path(expense)
    end

    it 'saves the modifications on the expense into the database.' do
      expect(page).to have_selector 'h1', text: 'Kiadás szerkesztése (first title)'

      expect(page).to have_selector 'label', text: 'Kiadás típusa'
      expect(page).to have_selector 'label', text: 'Címke'
      expect(page).to have_selector 'label', text: 'Összeg'
      expect(page).to have_selector 'label', text: 'Időpont'

      expect(page).to have_select 'expense_category_id', with_selected: 'First Category'
      expect(page).to have_field  'expense_title',       with: 'first title'
      expect(page).to have_field  'expense_amount',      with: 100
      expect(page).to have_field  'expense_realized_on', with: Date.yesterday.strftime('%F')

      select 'Second Category',      from: 'expense_category_id'
      fill_in 'expense_title',       with: 'second title'
      fill_in 'expense_amount',      with: 200
      fill_in 'expense_realized_on', with: Date.today.strftime('%F')

      expect { click_button 'Kiadás módosítása' }.to change { expense.reload.attributes.slice *%w[ category_id title amount realized_on ] }
        .from('category_id'=>first_category.id,  'title'=>'first title',  'amount'=>100, 'realized_on'=>Date.yesterday)
        .to(  'category_id'=>second_category.id, 'title'=>'second title', 'amount'=>200, 'realized_on'=>Date.today)

      expect(page).to have_selector 'h1', text: 'Kiadások listája (folyó hó)'
      expect(all('table#expenses tbody tr td').map(&:text)).to eq [ 'Second Category', 'second title', '200', I18n.l(Date.today, format: :short).squish, '' ]
    end

    it 'does not save modifications and displays error messages in case the changes do not pass the validation.' do
      expect(page).to have_selector 'h1', text: 'Kiadás szerkesztése (first title)'

      fill_in 'expense_title',       with: 'x' * 256
      fill_in 'expense_amount',      with: ''
      fill_in 'expense_realized_on', with: ''

      expect { click_button 'Kiadás módosítása' }.not_to change { expense.reload.attributes }
      expect(page).to have_selector 'h1', text: "Kiadás szerkesztése (#{'x' * 256})"
      expect(page).to have_field 'expense_title',       with: 'x' * 256
      expect(page).to have_field 'expense_amount',      with: ''
      expect(page).to have_field 'expense_realized_on', with: ''

      expect(page).to have_selector '#error_explanation', text: 'Címke túl hosszú'
      expect(page).to have_selector '#error_explanation', text: 'Összeg nincs megadva'
      expect(page).to have_selector '#error_explanation', text: 'Időpont nincs megadva'
    end
  end
# end
