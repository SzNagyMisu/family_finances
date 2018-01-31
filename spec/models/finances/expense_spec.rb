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
      it { should validate_presence_of :category_id }
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

        it 'returns the expenses realized in the given month.' do
          expect(described_class.pluck :realized_on).to match_array expenses_in_january.map(&:realized_on) + expenses_in_other_months.map(&:realized_on)
          expect(described_class.in_month(year, 1).pluck :realized_on).to match_array expenses_in_january.map(&:realized_on)
        end
      end
    end

    describe 'CLASS METHODS' do
    end

    describe 'INSTANCE METHODS' do
    end
  end
end
