require 'rails_helper'

module Finances
  RSpec.describe ExpenseCategoriesController, type: :controller do

    setup { @routes = Engine.routes }

    let(:valid_session) { {} }

    describe "GET #index" do
      let!(:expense_categories) { FactoryBot.create_list :finances_expense_category, 3 }

      before :each do
        get :index, params: {}, session: valid_session
      end

      it "returns a success response." do
        expect(response).to be_success
      end

      it 'stores all expense categories in @expense_categories.' do
        expect(assigns :expense_categories).to match_array expense_categories
      end
    end

    describe "GET #new" do
      before :each do
        get :new, params: {}, session: valid_session
      end

      it "returns a success response." do
        expect(response).to be_success
      end

      it 'stores a new expense category in @expense_category.' do
        expect(assigns :expense_category).to be_an ExpenseCategory
        expect(assigns(:expense_category).name).to be_nil
      end
    end

    describe "GET #edit" do
      let!(:expense_category) { FactoryBot.create :finances_expense_category, name: 'the chosen one' }
      let!(:other_category)   { FactoryBot.create :finances_expense_category, name: 'the other' }

      before :each do
        get :edit, params: {id: expense_category.to_param}, session: valid_session
      end

      it "returns a success response." do
        expect(response).to be_success
      end

      it 'stores the expense category identified by the :id passed in @expense_category.' do
        expect(assigns :expense_category).to eq expense_category
      end
    end

    describe "POST #create" do
      context "with valid params" do
        let(:attributes)   { FactoryBot.attributes_for :finances_expense_category }

        it "creates a new ExpenseCategory." do
          expect {
            post :create, params: {expense_category: attributes}, session: valid_session
          }.to change(ExpenseCategory, :count).by(1)
        end

        it "redirects to the index page." do
          post :create, params: {expense_category: attributes}, session: valid_session
          expect(response).to redirect_to(expense_categories_url)
        end
      end

      context "with invalid params" do
        let(:attributes) { { name: 'x' * 256 } }

        it 'does not create a new ExpenseCategory.' do
          expect { post :create, params: { expense_category: attributes }, session: valid_session }
            .to change(ExpenseCategory, :count).by 0
        end

        it "rerenders the new template with the ExpenseCategory object attributes and errors." do
          post :create, params: {expense_category: attributes}, session: valid_session
          expect(response).to be_success
          expect(response).to render_template :new

          expense_category = assigns :expense_category
          error_message    = expense_category.errors.generate_message :name, :too_long, count: 255
          expect(expense_category).to be_an ExpenseCategory
          expect(expense_category.name).to eq attributes[:name]
          expect(expense_category.errors.messages).to include name: [ error_message ]
        end
      end
    end

    describe "PATCH #update" do
      let(:expense_category) { FactoryBot.create           :finances_expense_category, name: 'before' }

      context "with valid params" do
        let(:attributes)       { FactoryBot.attributes_for :finances_expense_category, name: 'after' }

        it "updates the requested expense_category." do
          expect { patch :update, params: {id: expense_category.to_param, expense_category: attributes}, session: valid_session }
            .to change { expense_category.reload.name }.from('before').to('after')
        end

        it "redirects to the index page." do
          patch :update, params: {id: expense_category.to_param, expense_category: attributes}, session: valid_session
          expect(response).to redirect_to(expense_categories_url)
        end
      end

      context "with invalid params" do
        let(:attributes) { { name: '' } }

        it 'does not update the requested expense_category.' do
          expect { patch :update, params: {id: expense_category.to_param, expense_category: attributes}, session: valid_session }
            .not_to change { expense_category.reload.name }
        end

        it 'rerenders the edit template with the ExpenseCategory object attributes and errors' do
          patch :update, params: {id: expense_category.to_param, expense_category: attributes}, session: valid_session
          expect(response).to be_success
          expect(response).to render_template :edit

          edited_expense_category = assigns :expense_category
          error_message           = edited_expense_category.errors.generate_message :name, :blank
          expect(edited_expense_category).to be_an ExpenseCategory
          expect(edited_expense_category.name).to eq ''
          expect(edited_expense_category.errors.messages).to include name: [ error_message ]
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:expense_category) { FactoryBot.create :finances_expense_category }

      it "destroys the requested expense_category" do
        expect {
          delete :destroy, params: {id: expense_category.to_param}, session: valid_session
        }.to change(ExpenseCategory, :count).by(-1)
      end

      it "redirects to the expense_categories list" do
        delete :destroy, params: {id: expense_category.to_param}, session: valid_session
        expect(response).to redirect_to(expense_categories_url)
      end
    end

  end
end
