require_dependency "finances/application_controller"

module Finances
  class ExpenseCategoriesController < ApplicationController
    before_action :set_expense_category, only: [:show, :edit, :update, :destroy]

    # GET /expense_categories
    def index
      @expense_categories = ExpenseCategory.all
    end

    # GET /expense_categories/1
    def show
    end

    # GET /expense_categories/new
    def new
      @expense_category = ExpenseCategory.new
    end

    # GET /expense_categories/1/edit
    def edit
    end

    # POST /expense_categories
    def create
      @expense_category = ExpenseCategory.new(expense_category_params)

      if @expense_category.save
        redirect_to @expense_category, notice: 'Expense category was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /expense_categories/1
    def update
      if @expense_category.update(expense_category_params)
        redirect_to @expense_category, notice: 'Expense category was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /expense_categories/1
    def destroy
      @expense_category.destroy
      redirect_to expense_categories_url, notice: 'Expense category was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_expense_category
        @expense_category = ExpenseCategory.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def expense_category_params
        params.require(:expense_category).permit(:name)
      end
  end
end
