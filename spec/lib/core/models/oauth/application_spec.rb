RSpec.describe Core::Models::OAuth::Application do
  describe :name do
    it 'returns the right name for a built application' do
      expect(build(:application).name).to eq 'My wonderful test application'
    end
    it 'invalidates the application if the name is not given' do
      expect(build(:application, name: nil).valid?).to be false
    end
    it 'invalidates the application if the name is less than six characters' do
      expect(build(:application, name: 'test').valid?).to be false
    end
    it 'invalidates the application if the name is already taken' do
      create(:application)
      expect(build(:application).valid?).to be false
    end
  end

  describe :client_id do
    it 'returns the right client_id for a built application' do
      expect(build(:application, client_id: 'test_client_id').client_id).to eq 'test_client_id'
    end
    it 'invalidates the application if the client_id is not given' do
      expect(build(:application, client_id: nil).valid?).to be false
    end
    it 'invalidates the application if the client_id is already taken' do
      create(:application, client_id: 'test_client_id')
      expect(build(:application, client_id: 'test_client_id').valid?).to be false
    end
    it 'gives the client_id a default random value to the client_id' do
      expect(build(:application).client_id.size).to be 32
    end
  end

  describe :premium do
    it 'returns the premium status of the application' do
      expect(build(:application, premium: true).premium).to be true
    end
    it 'assigns a default value for an application, making it not premium' do
      expect(build(:application).premium).to be false
    end
  end

  describe :creator do
    it 'returns the correct creator for a built application' do
      expect(build(:application).creator.username).to eq 'Babausse'
    end
    it 'invalidates the application if no creator is given' do
      expect(build(:application, creator: nil).valid?).to be false
    end
  end

  describe :redirect_uris do
    it 'returns the correct list of URIs' do
      application = build(:application, redirect_uris: ['https://localhost:8080/'])
      expect(application.redirect_uris).to eq ['https://localhost:8080/']
    end
    it 'returns an empty list if no URI is added' do
      expect(build(:application).redirect_uris).to eq []
    end
    it 'invalidates the application if one of the URIs is not a string' do
      expect(build(:application, redirect_uris: [0]).valid?).to be false
    end
    it 'invalidates the application if one of the URIs has the wrong format' do
      expect(build(:application, redirect_uris: ['test']).valid?).to be false
    end
  end

  describe :accounts do
    it 'returns the right accounts for a given application' do
      expect(create(:application_with_authorizations).authorizations.count).to be 1
    end
    it 'returns the right account for an application with an authorization' do
      expect(create(:application_with_authorizations).authorizations.first.code).to eq 'test_code'
    end
  end

  describe 'errors.messages' do
    describe 'returns the right message if' do
      it 'the name is not given' do
        (app = build(:application, name: nil)).validate
        expect(app.errors.messages[:name]).to include('required')
      end
      it 'the name is in the wrong format' do
        (app = build(:application, name: 'a')).validate
        expect(app.errors.messages[:name]).to include('minlength')
      end
      it 'the name is already taken' do
        create(:application)
        (app = build(:application)).validate
        expect(app.errors.messages[:name]).to include('uniq')
      end
      it 'the client_id is not given' do
        (app = build(:application, client_id: nil)).validate
        expect(app.errors.messages[:client_id]).to include('required')
      end
      it 'the client_id is already taken' do
        create(:application, client_id: 'test_client_id')
        (app = build(:application, client_id: 'test_client_id')).validate
        expect(app.errors.messages[:client_id]).to include('uniq')
      end
      it 'one URI is not a string' do
        (app = build(:application, redirect_uris: [0])).validate
        expect(app.errors.messages[:redirect_uris]).to include('type')
      end
      it 'one URI has the wrong format' do
        (app = build(:application, redirect_uris: ['test'])).validate
        expect(app.errors.messages[:redirect_uris]).to include('format')
      end
    end
  end
end