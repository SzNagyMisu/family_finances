require 'rails_helper'

RSpec.describe 'Editing an expense category', type: :feature, js: true do
  let!(:category) { FactoryBot.create :finances_expense_category, name: 'The Expense Category' }

  before :each do
    visit finances.edit_expense_category_path(category)
  end

  it 'saves the modifications on the expense category into the database.' do
    expect(page).to have_selector 'h1', text: 'Kiadás típus szerkesztése'

    expect(page).to have_selector 'label', text: 'Megnevezés'
    expect(page).to have_field 'expense_category_name', with: 'The Expense Category'
    fill_in                    'expense_category_name', with: 'Another Expense Category'

    expect { click_button 'Kiadás típus módosítása' }.to change { category.reload.name }
      .from('The Expense Category').to('Another Expense Category')
    expect(page).to have_selector 'h1', text: 'Kiadás típusok listája'
    expect(page).to have_selector 'table#expense_categories tbody tr td', text: 'Another Expense Category'
  end

  it 'does not save modifications and displays error messages in case the changes do not pass the validation.' do
    expect(page).to have_selector 'h1', text: 'Kiadás típus szerkesztése'

    fill_in 'expense_category_name', with: 'x' * 256

    expect { click_button 'Kiadás típus módosítása' }.not_to change { category.reload.name }
    expect(page).to have_field 'expense_category_name', with: 'x' * 256
    expect(page).to have_selector '#error_explanation', text: 'Megnevezés túl hosszú'
  end
end
