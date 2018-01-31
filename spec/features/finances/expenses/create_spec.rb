require 'rails_helper'

RSpec.describe 'Creating a new expense', type: :feature, js: true do
  it 'saves a new expense record in the database' do
    visit finances.new_expense_path
    expect(page).to have_selector 'h1', text: 'Kiadás felvétele'
    expect(page).to have_selector 'label', text: 'Kategória'
    expect(page).to have_selector 'label', text: 'Címke'
    expect(page).to have_selector 'label', text: 'Összeg'
    expect(page).to have_selector 'label', text: 'Időpont'

    fill_in 'expense_title',       with: 'teszt kiadás'
    fill_in 'expense_amount',      with: '10_000'
    fill_in 'expense_realized_on', with: Date.today.to_s
    sleep
  end
end
