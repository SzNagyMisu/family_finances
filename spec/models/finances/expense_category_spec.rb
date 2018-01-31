require 'rails_helper'

module Finances
  RSpec.describe ExpenseCategory, type: :model do
    describe 'DB COLUMNS' do
      it { should have_db_column(:name).of_type(:string).with_options limit: 255 }
      include_examples 'timestamp columns'
    end

    describe 'DB INDICES' do
    end

    describe 'SERIALIZATIONS' do
    end

    describe 'ENUMS' do
    end

    describe 'VALIDATIONS' do
      subject { FactoryBot.create :finances_expense_category }

      it { should validate_presence_of :name }
      it { should validate_uniqueness_of :name }
      it { should validate_length_of(:name).is_at_most 255 }
    end

    describe 'ASSOCIATIONS' do
      it { should have_many(:expenses).with_foreign_key 'category_id' }
    end

    describe 'NESTED ATTRIBUTES' do
    end

    describe 'SCOPES' do
    end

    describe 'CLASS METHODS' do
    end

    describe 'INSTANCE METHODS' do
      describe '#destroy' do
        subject! { FactoryBot.create :finances_expense_category }

        context 'if there is no expense belonging to the category,' do
          it 'deletes the record in the database.' do
            expect { subject.destroy }.to change(described_class, :count).by -1
            expect(subject).to be_destroyed
          end
        end

        context 'if there is at least one expense belonging to the category,' do
          let!(:expense) { FactoryBot.create :finances_expense, category: subject }
          let!(:message) { subject.errors.generate_message(:base, 'restrict_dependent_destroy.has_many') }

          it 'adds a validation error and does not delete the record.' do
            expect { subject.destroy }.to change(described_class, :count).by 0
            expect(subject).not_to be_destroyed
            expect(subject.errors.messages).to include base: [ message ]
          end
        end
      end

      describe '#destroy!' do
        subject! { FactoryBot.create :finances_expense_category }

        context 'if there is no expense belonging to the category,' do
          it 'deletes the record in the database.' do
            expect { subject.destroy! }.to change(described_class, :count).by -1
            expect(subject).to be_destroyed
          end
        end

        context 'if there is at least one expense belonging to the category,' do
          let!(:expense) { FactoryBot.create :finances_expense, category: subject }
          let!(:message) { subject.errors.generate_message(:base, 'restrict_dependent_destroy.has_many') }

          it 'adds a validation error and does not delete the record.' do
            expect { subject.destroy! }
              .to raise_exception(::ActiveRecord::RecordNotDestroyed)
              .and change(described_class, :count).by 0
            expect(subject).not_to be_destroyed
            expect(subject.errors.messages).to include base: [ message ]
          end
        end
      end
    end
  end
end
