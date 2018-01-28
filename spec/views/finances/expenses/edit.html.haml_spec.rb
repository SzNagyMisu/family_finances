require 'rails_helper'

RSpec.describe "expenses/edit", type: :view do
  before(:each) do
    @expense = assign(:expense, Expense.create!(
      :category => nil,
      :title => "MyString",
      :amount => 1
    ))
  end

  it "renders the edit expense form" do
    render

    assert_select "form[action=?][method=?]", expense_path(@expense), "post" do

      assert_select "input[name=?]", "expense[category_id]"

      assert_select "input[name=?]", "expense[title]"

      assert_select "input[name=?]", "expense[amount]"
    end
  end
end
