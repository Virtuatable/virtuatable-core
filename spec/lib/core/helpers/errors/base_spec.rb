RSpec.describe Core::Helpers::Errors::Base do
  let!(:exception) { build(:base_error) }

  it 'Has a status set at creation' do
    expect(exception.status).to be 500
  end
  it 'has a field set at creation' do
    expect(exception.field).to eq 'concerned_field'
  end
  it 'has an error set at creation' do
    expect(exception.error).to eq 'returned_error'
  end
  it 'can be used as an error class' do
    expect(exception).to be_a_kind_of StandardError
  end
end