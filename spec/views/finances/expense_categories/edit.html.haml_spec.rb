require 'rails_helper'

RSpec.describe "expense_categories/edit", type: :view do
  before(:each) do
    @expense_category = assign(:expense_category, ExpenseCategory.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit expense_category form" do
    render

    assert_select "form[action=?][method=?]", expense_category_path(@expense_category), "post" do

      assert_select "input[name=?]", "expense_category[name]"
    end
  end
end
