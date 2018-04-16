require 'rails_helper'

module Finances
  RSpec.describe ExpensesController, type: :controller do

    setup { @routes = Engine.routes }

    let(:valid_session) { {} }

    describe "GET #index" do
      context 'not nested under an expense category,' do
        let!(:actual_expenses)     { FactoryBot.create_list :finances_expense, 2, realized_on: Date.today }
        let!(:last_month_expenses) { FactoryBot.create_list :finances_expense, 3, realized_on: 1.month.ago }

        context 'without parameter month,' do
          subject! { get :index, params: {}, session: valid_session }

          it { should be_success }
          it 'stores expenses of the current month in @expenses.' do
            expect(assigns :expenses).to match_array actual_expenses
          end
        end

        context 'with parameter month,' do
          subject! { get :index, params: { month: 1.month.ago.strftime('%Y-%m') }, session: valid_session }

          it { should be_success }

          it 'stores expenses of the given month in @expenses.' do
            expect(assigns :expenses).to match_array last_month_expenses
          end
        end
      end

      context 'nested under an expense category,' do
        let!(:category) { FactoryBot.create :finances_expense_category }
        let!(:actual_expense_of_category)           { FactoryBot.create :finances_expense, category: category, realized_on: Date.today }
        let!(:last_month_expense_of_category)       { FactoryBot.create :finances_expense, category: category, realized_on: 1.month.ago }
        let!(:actual_expense_of_other_category)     { FactoryBot.create :finances_expense, realized_on: Date.today }
        let!(:last_month_expense_of_other_category) { FactoryBot.create :finances_expense, realized_on: 1.month.ago }

        context 'without parameter month,' do
          subject! { get :index, params: { expense_category_id: category.to_param }, session: valid_session }

          it { should be_success }

          it 'stores the expense category in @expense_category.' do
            expect(assigns :expense_category).to eq category
          end

          it 'stores expenses of the current month belonging to the category in @expenses.' do
            expect(assigns :expenses).to match_array [ actual_expense_of_category ]
          end
        end

        context 'with parameter month,' do
          subject! { get :index, params: { expense_category_id: category.to_param, month: 1.month.ago.strftime('%Y-%m') }, session: valid_session }

          it { should be_success }

          it 'stores the expense category in @expense_category.' do
            expect(assigns :expense_category).to eq category
          end

          it 'stores expenses of the given month belonging to the category in @expenses.' do
            expect(assigns :expenses).to match_array [ last_month_expense_of_category]
          end
        end
      end

      # it 'preloads :expense_category relations for @expenses' do
      #   expenses_queried = assigns(:expenses).load # TODO matcher
      #   allow(ActiveRecord::Base.connection).to receive(:inspect).and_return('#<ActiveRecord::ConnectionAdapters::Mysql2Adapter>')
      #   expect(ActiveRecord::Base.connection).not_to receive :exec_query
      #   expenses_queried.map &:category_name
      # end
    end

    describe "GET #new" do
      before :each do
        get :new, params: {}, session: valid_session
      end

      it "returns a success response." do
        expect(response).to be_success
      end

      it 'stores a new Expense in @expense' do
        expect(assigns :expense).to be_an(Expense).and be_new_record
      end
    end

    describe "GET #edit" do
      let!(:expense)       { FactoryBot.create :finances_expense, title: 'the chosen one' }
      let!(:other_expense) { FactoryBot.create :finances_expense, title: 'the other' }

      before :each do
        expect(Expense.pluck :title).to match_array [ 'the chosen one', 'the other' ]
        get :edit, params: {id: expense.to_param}, session: valid_session
      end

      it "returns a success response." do
        expect(response).to be_success
      end

      it 'stores the Expense identified by param[:id] in @expense.' do
        expect(assigns(:expense).title).to eq 'the chosen one'
      end
    end

    describe "POST #create" do
      context "with valid params" do
        let(:category)   { FactoryBot.create         :finances_expense_category }
        let(:attributes) { FactoryBot.attributes_for(:finances_expense).merge(category_id: category.id) }

        it "creates a new Expense." do
          expect { post :create, params: { expense: attributes }, session: valid_session }
            .to change(Expense, :count).by(1)
        end

        it "redirects to the index page with success flash message." do
          post :create, params: { expense: attributes }, session: valid_session
          expect(response).to redirect_to(Expense)
          expect(flash[:notice]).to eq 'A kiadás sikeresen létrejött.'
        end
      end

      context "with invalid params" do
        let(:attributes) { { title: '' } }

        it 'does not create a new Expense.' do
          expect { post :create, params: { expense: attributes }, session: valid_session }
            .to change(Expense, :count).by 0
        end

        it 'renders the :new template with the errors.' do
          post :create, params: { expense: attributes }, session: valid_session
          expect(response).to render_template(:new)
          error_message = assigns(:expense).errors.generate_message :title, :blank
          expect(assigns(:expense).errors.messages).to include title: [ error_message ]
        end
      end
    end

    describe "PATCH #update" do
      let!(:category)   { FactoryBot.create :finances_expense_category }
      let!(:expense)    { FactoryBot.create :finances_expense, category: category }

      context "with valid params" do
        let(:attributes) { { category_id: category.id, title: 'vacsora', amount: 1500, realized_on: Date.today } }

        it "updates the requested expense." do
          expect { patch :update, params: {id: expense.to_param, expense: attributes}, session: valid_session }
            .to change { expense.reload.attributes.symbolize_keys }.to include attributes
        end

        it "redirects to the index page." do
          patch :update, params: { id: expense.to_param, expense: attributes }, session: valid_session
          expect(response).to redirect_to(Expense)
          expect(flash[:notice]).to eq 'A kiadás sikeresen módosult.'
        end
      end

      context "with invalid params" do
        let(:attributes) { { title: '' } }

        it 'rerenders the :edit template with the error messages.' do
          patch :update, params: {id: expense.to_param, expense: attributes}, session: valid_session
          expect(response).to render_template :edit
          expect(assigns(:expense).attributes).to include expense.attributes.merge attributes.stringify_keys
          error_message = expense.errors.generate_message :title, :blank
          expect(assigns(:expense).errors.messages).to include title: [ error_message ]
        end

        it 'does not save the changes to the database.' do
          expect { patch :update, params: { id: expense.to_param, expense: attributes }, session: valid_session }
            .not_to change { expense.reload.title }
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:expense) { FactoryBot.create :finances_expense }

      it "destroys the requested expense." do
        expect { delete :destroy, params: {id: expense.to_param}, session: valid_session }
          .to change(Expense, :count).by(-1)
      end

      it "redirects to the expenses list." do
        delete :destroy, params: {id: expense.to_param}, session: valid_session
        expect(response).to redirect_to(expenses_url)
        expect(flash[:notice]).to eq 'A kiadás sikeresen törlődött.'
      end
    end

    describe 'GET #statistics' do
      let!(:category_1) { FactoryBot.create :finances_expense_category, name: 'Category 1' }
      let!(:category_2) { FactoryBot.create :finances_expense_category, name: 'Category 2' }
      let!(:expense_1)  { FactoryBot.create :finances_expense, category: category_1, amount: 100, realized_on: Date.today }
      let!(:expense_2)  { FactoryBot.create :finances_expense, category: category_1, amount: 200, realized_on: Date.today }
      let!(:expense_3)  { FactoryBot.create :finances_expense, category: category_2, amount: 400, realized_on: Date.today }
      let!(:expense_4)  { FactoryBot.create :finances_expense, category: category_1, amount: 800, realized_on: 1.month.ago }

      context 'when called without param :month,' do
        subject! { get :statistics, params: {}, session: valid_session }

        it { should be_success }

        it 'stores the sum of the expenses of the current month (grouped by category and reverse ordered by amount) in @stats.' do
          statistics = assigns :stats
          expect(statistics.map &:sum_amount).to eq [ 400, 300 ] # reverse ordered by #sum_amount
          expect(statistics.map &:expense_category_name).to eq [ 'Category 2', 'Category 1' ]
        end

        it 'stores the total sum of the current month in @total.' do
          expect(assigns :total).to eq 700
        end
      end

      context 'when called with param :month,' do
        subject! { get :statistics, params: { month: 1.month.ago.strftime('%Y-%m') }, session: valid_session }

        it { should be_success }

        it 'stores the sum of the expenses of the given month (grouped by category and reverse ordered by amount) in @stats.' do
          statistics = assigns :stats
          expect(statistics.first.sum_amount).to eq 800
          expect(statistics.first.expense_category_name).to eq 'Category 1'
        end

        it 'stores the total sum of the given month in @total.' do
          expect(assigns :total).to eq 800
        end
      end

      context 'when called with "all" as param :month,' do
        subject! { get :statistics, params: { month: 'all' }, session: valid_session }

        it { should be_success }

        it 'stores the sum of the expenses of all the months (grouped by category and reverse ordered by amount) in @stats.' do
          statistics = assigns :stats
          expect(statistics.map &:sum_amount).to eq [ 1100, 400 ] # reverse ordered by #sum_amount
          expect(statistics.map &:expense_category_name).to eq [ 'Category 1', 'Category 2' ]
        end

        it 'stores the total sum of all the months in @total.' do
          expect(assigns :total).to eq 1500
        end
      end
    end

  end
end
