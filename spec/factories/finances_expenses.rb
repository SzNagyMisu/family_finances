FactoryBot.define do
  factory :finances_expense, class: 'Finances::Expense' do
    association :category, factory: :finances_expense_category
    title 'kiadás oka'
    amount 10_000
    realized_on "2018-01-28"
  end
end
