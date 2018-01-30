require 'rails_helper'

RSpec.describe 'Creating a new expense', type: :feature, js: true do
  it 'saves a new expense record in the database' do
    visit finances.new_expense_path
    sleep
  end
end
