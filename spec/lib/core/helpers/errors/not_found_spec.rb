RSpec.describe Core::Helpers::Errors::NotFound do
  let!(:exception) { build(:not_found_error) }
  
  it 'has a status set to 404 at creation' do
    expect(exception.status).to be 404
  end
  it 'has a field set at creation' do
    expect(exception.field).to eq 'concerned_field'
  end
  it 'has an error set at creation' do
    expect(exception.error).to eq 'unknown'
  end
  it 'can be used as an error class' do
    expect(exception).to be_a_kind_of StandardError
  end
end