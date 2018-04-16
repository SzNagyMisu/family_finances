require 'rails_helper'

module Finances
  RSpec.describe Expense, type: :model do
    describe 'DB COLUMNS' do
      it { should have_db_column(:category_id).of_type(:integer).with_options null: false, foreign_key: { to_table: :finances_expense_categories } }
      it { should have_db_column(:title)      .of_type(:string) .with_options null: false, limit: 255 }
      it { should have_db_column(:amount)     .of_type(:integer).with_options null: false, limit: 4 }
      it { should have_db_column(:realized_on).of_type(:date)   .with_options null: false }
      include_examples 'timestamp columns'
    end

    describe 'DB INDICES' do
      it { should have_db_index(:category_id) }
    end

    describe 'SERIALIZATIONS' do
    end

    describe 'ENUMS' do
    end

    describe 'VALIDATIONS' do
      # it { should validate_presence_of :category_id }
      it { should validate_presence_of :title }
      it { should validate_presence_of :amount }
      it { should validate_presence_of :realized_on }
      it { should validate_length_of(:title).is_at_most 255 }
      it { should validate_numericality_of :amount }
      it { should validate_inclusion_of(:amount).in_range 0..2147483647 }
    end

    describe 'ASSOCIATIONS' do
      it { should belong_to(:category).class_name 'ExpenseCategory' }
    end

    describe 'NESTED ATTRIBUTES' do
    end

    describe 'SCOPES' do
      describe '.in_month' do
        let(:year) { Date.today.year }
        let! :expenses_in_january do
          (10..30).step(10).map do |day|
            FactoryBot.create :finances_expense, realized_on: Date.new(year, 1, day)
          end
        end
        let! :expenses_in_other_months do
          (2..12).map do |month|
            FactoryBot.create :finances_expense, realized_on: Date.new(year, month, 10)
          end
        end

        it 'returns the expenses realized in the given month (given in string format yyyy-mm).' do
          expect(described_class.pluck :realized_on).to match_array expenses_in_january.map(&:realized_on) + expenses_in_other_months.map(&:realized_on)
          expect(described_class.in_month("#{year}-01").pluck :realized_on).to match_array expenses_in_january.map(&:realized_on)
        end

        it 'returns all expenses if given the param "all".' do
          expect(described_class.in_month('all').pluck :realized_on).to match_array described_class.pluck :realized_on
        end

        it 'returns the expenses of the current month if given the param :current' do
          Timecop.freeze Date.new year, 2, 15 do
            expect(described_class.in_month(:current).pluck :realized_on).to match_array [ expenses_in_other_months.first.realized_on ]
          end
        end

        it 'raises ArgumentError if month is given in a wrong format.' do
          expect { described_class.in_month 'wrong format' }.to raise_exception ArgumentError
        end
      end

      describe '.statistics' do
        let!(:category_1) { FactoryBot.create :finances_expense_category, name: 'Category 1' }
        let!(:category_2) { FactoryBot.create :finances_expense_category, name: 'Category 2' }
        let!(:expense_1)  { FactoryBot.create :finances_expense, category: category_1, amount: 100, realized_on: Date.today }
        let!(:expense_2)  { FactoryBot.create :finances_expense, category: category_1, amount: 200, realized_on: Date.today }
        let!(:expense_3)  { FactoryBot.create :finances_expense, category: category_2, amount: 400, realized_on: Date.today }
        let!(:expense_4)  { FactoryBot.create :finances_expense, category: category_1, amount: 800, realized_on: 1.month.ago }

        it 'returns the expense amounts summed by their expense category.' do
          statistics = described_class.statistics
          expect(statistics.find { |stat| stat.expense_category_name == 'Category 1' }.sum_amount).to eq 1100
          expect(statistics.find { |stat| stat.expense_category_name == 'Category 2' }.sum_amount).to eq 400
        end

        context 'when used with .in_month,' do
          it 'returns statistics only for the month given.' do
            statistics = described_class.statistics.in_month Date.today.strftime('%Y-%m')
            expect(statistics.find { |stat| stat.expense_category_name == 'Category 1' }.sum_amount).to eq 300
            expect(statistics.find { |stat| stat.expense_category_name == 'Category 2' }.sum_amount).to eq 400
          end
        end
      end
    end

    describe 'CLASS METHODS' do
    end

    describe 'INSTANCE METHODS' do
      describe '#category_name' do
        let(:expense_category)    { FactoryBot.create :finances_expense_category, name: 'Turul' }
        let(:expense)             { FactoryBot.create :finances_expense, category: expense_category }
        let(:invalid_new_expense) { FactoryBot.build  :finances_expense, category: nil }

        it 'returns the name of the category of the expense.' do
          expect(expense.category_name).to eq 'Turul'
        end

        it 'returns nil if expense does not have a category yet (only possible if new record).' do
          expect(invalid_new_expense.category_name).to be_nil
        end
      end
    end
  end
end
