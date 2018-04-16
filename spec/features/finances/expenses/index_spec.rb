require 'rails_helper'

RSpec.describe 'The expenses index page', type: :feature, js: true do
  let!(:category_1) { FactoryBot.create :finances_expense_category, name: 'first category' }
  let!(:category_2) { FactoryBot.create :finances_expense_category, name: 'second category' }
  let!(:expense_1)  { FactoryBot.create :finances_expense, category: category_1, title: 'first expense',  amount: 100, realized_on: Date.today }
  let!(:expense_2)  { FactoryBot.create :finances_expense, category: category_2, title: 'second expense', amount: 200, realized_on: Date.today }
  let!(:expense_3)  { FactoryBot.create :finances_expense, category: category_2, title: 'third expense',  amount: 400, realized_on: 1.month.ago }

  it 'gives possibility to edit or destroy an expense, to add new expense or expense category.' do
    visit finances.expenses_path
    expect(page).to have_selector 'h1', text: 'Kiadások listája (folyó hó)'

    within 'table#expenses tbody' do
      accept_confirm { within('tr:first-child') { click_link 'törlés' } }
      expect(page).to have_selector 'tr', count: 1
      expect(Finances::Expense.in_month(:current).count).to eq 1
      click_link 'szerkesztés'
      expect(current_url).to match /#{finances.edit_expense_path expense_2}\z/
      page.driver.go_back
    end
  end

  context 'if parameter :month not given,' do
    it 'shows the expenses of the current month.' do
      visit finances.expenses_path
      expect(page).to have_selector 'h1', text: 'Kiadások listája (folyó hó)'

      within 'table#expenses' do
        expect(all('thead tr th').map &:text).to eq [ 'Kiadás típusa', 'Címke', 'Összeg', 'Időpont', '' ]
        expect(page).to have_selector 'tbody tr', count: 2
        expect(all('tbody tr:first-child td').map &:text).to eq [ 'first category',  'first expense',  '100', I18n.l(Date.today, format: :short).squish, '' ]
        expect(all('tbody tr:last-child td') .map &:text).to eq [ 'second category', 'second expense', '200', I18n.l(Date.today, format: :short).squish, '' ]
      end

      expect(page).to have_selector "a[href='#{finances.new_expense_path}']", text: 'Kiadás felvétele'
    end
  end

  context 'if parameter :month is set to "yyyy-mm",' do
    it 'shows the expenses for the given month.' do
      visit finances.month_expenses_path 1.month.ago.strftime('%Y-%m')
      expect(page).to have_selector 'h1', text: "Kiadások listája (#{1.month.ago.strftime '%Y-%m'})"

      within 'table#expenses' do
        expect(all('thead tr th').map &:text).to eq [ 'Kiadás típusa', 'Címke', 'Összeg', 'Időpont', '' ]
        expect(page).to have_selector 'tbody tr', count: 1
        expect(all('tbody tr td').map &:text).to eq [ 'second category', 'third expense', '400', I18n.l(1.month.ago.to_date, format: :short).squish, '' ]
      end
    end
  end

  context 'if parameter :month is set to "all",' do
    it 'shows the expenses for all months.' do
      visit finances.month_expenses_path 'all'
      expect(page).to have_selector 'h1', text: /\AKiadások listája\z/

      within 'table#expenses' do
        expect(all('thead tr th').map &:text).to eq [ 'Kiadás típusa', 'Címke', 'Összeg', 'Időpont', '' ]
        expect(page).to have_selector 'tbody tr', count: 3
        expect(all('tbody tr td:nth-child(2)').map &:text).to eq [ 'first expense', 'second expense', 'third expense' ]
      end
    end
  end

  context 'if nested under expense category' do
    it 'shows all the expenses belonging to that category' do
      visit finances.expense_category_expenses_path category_2
      expect(page).to have_selector 'h1', text: 'Kiadások listája (second category)'
    end
  end
end
