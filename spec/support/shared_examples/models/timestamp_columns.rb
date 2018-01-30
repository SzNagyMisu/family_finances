RSpec.shared_examples 'timestamp columns' do
  it { should have_db_column(:created_at).of_type(:datetime).with_options null: false }
  it { should have_db_column(:updated_at).of_type(:datetime).with_options null: false }
end
