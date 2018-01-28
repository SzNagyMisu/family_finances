require 'rails_helper'

RSpec.describe "expense_categories/index", type: :view do
  before(:each) do
    assign(:expense_categories, [
      ExpenseCategory.create!(
        :name => "Name"
      ),
      ExpenseCategory.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of expense_categories" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
