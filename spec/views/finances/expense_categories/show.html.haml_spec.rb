require 'rails_helper'

RSpec.describe "expense_categories/show", type: :view do
  before(:each) do
    @expense_category = assign(:expense_category, ExpenseCategory.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
