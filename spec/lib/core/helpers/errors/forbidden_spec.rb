RSpec.describe Core::Helpers::Errors::Forbidden do
  let!(:exception) { build(:forbidden_error) }
  
  it 'has a status set to 404 at creation' do
    expect(exception.status).to be 403
  end
  it 'has a field set at creation' do
    expect(exception.field).to eq 'concerned_field'
  end
  it 'has an error set at creation' do
    expect(exception.error).to eq 'forbidden'
  end
  it 'can be used as an error class' do
    expect(exception).to be_a_kind_of StandardError
  end
end