FactoryBot.define do
  factory :finances_expense_category, class: 'Finances::ExpenseCategory' do
    sequence(:name) { |n| "Kiadás kategória - #{n}" }
  end
end
