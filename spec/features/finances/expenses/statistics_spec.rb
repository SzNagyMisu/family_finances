require 'rails_helper'

RSpec.describe 'The expenses statistics page', type: :feature, js: true do
  let!(:category_1) { FactoryBot.create :finances_expense_category, name: 'Category 1' }
  let!(:category_2) { FactoryBot.create :finances_expense_category, name: 'Category 2' }
  let!(:expense_1) { FactoryBot.create :finances_expense, amount: 100, category: category_1, realized_on: Date.today }
  let!(:expense_2) { FactoryBot.create :finances_expense, amount: 200, category: category_1, realized_on: Date.today }
  let!(:expense_3) { FactoryBot.create :finances_expense, amount: 400, category: category_2, realized_on: Date.today }
  let!(:expense_4) { FactoryBot.create :finances_expense, amount: 800, category: category_2, realized_on: 1.month.ago }

  it 'shows statistics (reverse ordered by the amount sum) for the current month if parameter month is not given.' do
    visit finances.statistics_expenses_path
    expect(page).to have_selector 'h1', text: 'Kiadás statisztika (folyó hó)'

    within 'table#expenses_statistics' do
      expect(all('thead tr th').map &:text).to eq [ 'Kiadás típusa', 'Összeg' ]
      expect(all('tbody tr:first-child  td').map &:text).to eq [ 'Category 2', '400' ]
      expect(all('tbody tr:nth-child(2) td').map &:text).to eq [ 'Category 1', '300' ]
      expect(all('tbody tr:last-child >  *').map &:text).to eq [ 'Összesen', '700' ]
    end
  end

  it 'shows statistics (reverse ordered by the amount sum) for the month given as parameter month.' do
    visit finances.statistics_expenses_path 1.month.ago.strftime('%Y-%m')
    expect(page).to have_selector 'h1', text: "Kiadás statisztika (#{1.month.ago.strftime('%Y-%m')})"

    within 'table#expenses_statistics' do
      expect(all('thead tr th').map &:text).to eq [ 'Kiadás típusa', 'Összeg' ]
      expect(all('tbody tr:first-child  td').map &:text).to eq [ 'Category 2', '800' ]
      expect(all('tbody tr:last-child >  *').map &:text).to eq [ 'Összesen', '800' ]
    end
  end

  it 'shows statistics (reverse ordered by the amount sum) for every months if "all" is passed as parameter month.' do
    visit finances.statistics_expenses_path 'all'
    expect(page).to have_selector 'h1', text: 'Kiadás statisztika'

    within 'table#expenses_statistics' do
      expect(all('thead tr th').map &:text).to eq [ 'Kiadás típusa', 'Összeg' ]
      expect(all('tbody tr:first-child  td').map &:text).to eq [ 'Category 2', '1200' ]
      expect(all('tbody tr:nth-child(2) td').map &:text).to eq [ 'Category 1', '300' ]
      expect(all('tbody tr:last-child >  *').map &:text).to eq [ 'Összesen', '1500' ]
    end
  end
end
