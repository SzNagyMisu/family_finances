require 'rails_helper'

RSpec.describe 'The index categories index page', type: :feature, js: true do
  let!(:category_1) { FactoryBot.create :finances_expense_category, name: 'Category 1' }
  let!(:category_2) { FactoryBot.create :finances_expense_category, name: 'Category 2' }

  it 'shows the existing expense categories.' do
    visit finances.expense_categories_path
    expect(page).to have_selector 'h1', text: 'Kiadás típusok listája'

    within 'table#expense_categories' do
      expect(page).to have_selector 'thead th', text: 'Megnevezés'
      expect(page).to have_selector 'tbody tr', count: 2
      expect(all('tbody td:first-child').map &:text).to eq [ 'Category 1', 'Category 2' ]
    end
  end

  it 'gives possibility to create expense category.' do
    visit finances.expense_categories_path
    expect(page).to have_selector 'h1', text: 'Kiadás típusok listája'

    click_link 'Kiadás típus felvétele'
    expect(page).to have_selector 'h1', text: 'Új kiadás típus'
    expect(current_url).to match /#{finances.new_expense_category_path}/
  end

  it 'gives possibility to edit expense category.' do
    visit finances.expense_categories_path
    expect(page).to have_selector 'h1', text: 'Kiadás típusok listája'

    within('#expense_categories tbody tr:first-child') { click_link 'szerkesztés' }
    expect(page).to have_selector 'h1', text: 'Kiadás típus szerkesztése'
    expect(current_url).to match /#{finances.edit_expense_category_path category_1}\z/
  end

  it 'gives possibility to destroy expense category.' do
    visit finances.expense_categories_path
    expect(page).to have_selector 'h1', text: 'Kiadás típusok listája'

    within '#expense_categories tbody tr:first-child' do
      accept_confirm 'Biztosan törlöd ezt a kiadás típust?' do
        click_link 'törlés'
      end
    end
    expect(page).to have_selector 'h1', text: 'Kiadás típusok listája'
    expect(page).to have_selector '#expense_categories tbody tr', count: 1
  end

  it 'does not destroy the expense category if it has any expenses.' do
    FactoryBot.create :finances_expense, category: category_1
    visit finances.expense_categories_path
    expect(page).to have_selector 'h1', text: 'Kiadás típusok listája'

    within '#expense_categories tbody tr:first-child' do
      accept_confirm 'Biztosan törlöd ezt a kiadás típust?' do
        click_link 'törlés'
      end
    end
    expect(page).to have_selector 'h1', text: 'Kiadás típusok listája'
    expect(page).to have_selector '#expense_categories tbody tr', count: 2
  end

  it 'gives possibility to see the expenses belonging to the expense.' do
    visit finances.expense_categories_path
    expect(page).to have_selector 'h1', text: 'Kiadás típusok listája'

    within('#expense_categories tbody tr:first-child') { click_link 'kiadások' }
    expect(page).to have_selector 'h1', text: 'Kiadások listája (Category 1)'
    expect(current_url).to match /#{finances.expense_category_expenses_path category_1}\z/
  end
end
