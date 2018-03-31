require_dependency "finances/application_controller"

module Finances
  class ExpensesController < ApplicationController
    before_action :set_expense, only: [:show, :edit, :update, :destroy]

    # GET /expenses
    def index
      if (expense_category_id = params[:expense_category_id]).present?
        @expense_category = ExpenseCategory.find(expense_category_id)
        @expenses         = @expense_category.expenses
      else
        @expenses         = Expense.all
      end

      @expenses = @expenses.in_month(month).includes :category
    end

    # GET /expenses/new
    def new
      @expense = Expense.new realized_on: Date.today
    end

    # GET /expenses/1/edit
    def edit
    end

    # POST /expenses
    def create
      @expense = Expense.new(expense_params)

      if @expense.save
        redirect_to Expense, notice: 'A kiadás sikeresen létrejött.'
      else
        render :new
      end
    end

    # PATCH/PUT /expenses/1
    def update
      if @expense.update(expense_params)
        redirect_to Expense, notice: 'A kiadás sikeresen módosult.'
      else
        render :edit
      end
    end

    # DELETE /expenses/1
    def destroy
      @expense.destroy
      redirect_to expenses_url, notice: 'A kiadás sikeresen törlődött.'
    end

    def statistics
      @stats = Expense.statistics.in_month(month).order('sum_amount DESC')
      @total = Expense.in_month(month).sum :amount
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_expense
        @expense = Expense.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def expense_params
        params.require(:expense).permit(:category_id, :title, :amount, :realized_on)
      end

      def month
        params[:month] || :current
      end
  end
end
