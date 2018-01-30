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
    end

    describe 'ASSOCIATIONS' do
    end

    describe 'NESTED ATTRIBUTES' do
    end

    describe 'SCOPES' do
    end

    describe 'CLASS METHODS' do
    end

    describe 'INSTANCE METHODS' do
    end
  end
end
