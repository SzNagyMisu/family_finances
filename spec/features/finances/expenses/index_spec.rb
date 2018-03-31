require 'rails_helper'

RSpec.describe 'The expenses index page', type: :feature, js: true do
  let!(:category_1) { FactoryBot.create :finances_expense_category, name: 'first category' }
  let!(:category_2) { FactoryBot.create :finances_expense_category, name: 'second category' }
  let!(:expense_1)  { FactoryBot.create :finances_expense, category: category_1, title: 'first expense',  amount: 100, realized_on: Date.today }
  let!(:expense_2)  { FactoryBot.create :finances_expense, category: category_2, title: 'second expense', amount: 200, realized_on: Date.today }
  let(:realized_on) { I18n.l(Date.today, format: :short).squish }

  before :each do
    visit finances.expenses_path
  end

  it 'shows the existing expenses.' do
    expect(page).to have_selector 'h1', text: 'Kiadások listája'
    expect(page).to have_selector 'table#expenses'

    within 'table#expenses' do
      expect(all('thead tr th').map &:text).to eq [ 'Kiadás típusa', 'Címke', 'Összeg', 'Időpont', '' ]
      expect(all('tbody tr:first-child td').map &:text).to eq [ 'first category',  'first expense',  '100', realized_on, '' ]
      expect(all('tbody tr:last-child td') .map &:text).to eq [ 'second category', 'second expense', '200', realized_on, '' ]
    end

    expect(page).to have_selector "a[href='#{finances.new_expense_path}']", text: 'Kiadás felvétele'
  end

  it 'gives possibility to edit or destroy an expense, to add new expense or expense category.' do
    within 'table#expenses tbody' do
      accept_confirm { within('tr:first-child') { click_link 'törlés' } }
      expect(page).to have_selector 'tr', count: 1
      expect(Finances::Expense.count).to eq 1
      click_link 'szerkesztés'
      expect(current_url).to match /#{finances.edit_expense_path expense_2}\z/
      page.driver.go_back
    end
  end
end
