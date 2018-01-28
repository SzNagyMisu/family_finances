FactoryBot.define do
  factory :finances_expense, class: 'Finances::Expense' do
    category nil
    title "MyString"
    amount 1
    realized_on "2018-01-28"
  end
end
