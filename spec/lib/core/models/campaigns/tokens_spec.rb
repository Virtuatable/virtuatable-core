RSpec.describe Core::Models::Campaigns::Token do
  describe :name do
    let!(:account) { create(:account) }
    let!(:campaign) { create(:campaign, creator: account) }
    let!(:token) { create(:token, campaign: campaign, creator: account) }

    it 'Has a name set at creation' do
      expect(token.name).to eq 'Babausse'
    end
    describe 'empty name error' do
      before { token.name = nil }

      it 'invalidates the token if name is not given' do
        expect(token.valid?).to be false
      end
      it 'returns the correct error message' do
        token.validate
        expect(token.errors.messages[:name]).to eq ['required']
      end
    end
    describe 'minlength name error' do
      before { token.name = 'a' }

      it 'invalidates the token if name is too short' do
        expect(token.valid?).to be false
      end
      it 'returns the correct error message' do
        token.validate
        expect(token.errors.messages[:name]).to eq ['minlength']
      end
    end
  end
end

RSpec.describe Core::Models::Campaigns::TokenPosition do
  let!(:account) { create(:account) }
  let!(:campaign) { create(:campaign, creator: account) }
  let!(:token) { create(:token, campaign: campaign, creator: account) }
  let!(:map) { create(:map, campaign: campaign, width: 10, height: 10) }

  describe :x do
    it 'has an X coordinate set at creation' do
      expect(create(:position, token: token, map: map).x).to be 0
    end
    it 'has the correct X if it is set by the user' do
      expect(create(:position, token: token, map: map, x: 1).x).to be 1
    end
    it 'fails to validate if the X is below zero' do
      expect(build(:position, token: token, map: map, x: -1).valid?).to be false
    end
    it 'fails to validate if the X is outside the map' do
      expect(build(:position, token: token, map: map, x: 10).valid?).to be false
    end
    it 'returns the correct message when bounds are not respected' do
      position = build(:position, token: token, map: map, x: -1)
      position.validate
      expect(position.errors.messages[:x]).to eq ['bounds']
    end
  end

  describe :y do
    it 'has an Y coordinate set at creation' do
      expect(create(:position, token: token, map: map).y).to be 0
    end
    it 'has the correct Y if it is set by the user' do
      expect(create(:position, token: token, map: map, y: 1).y).to be 1
    end
    it 'fails to validate if the Y is below zero' do
      expect(build(:position, token: token, map: map, y: -1).valid?).to be false
    end
    it 'fails to validate if the Y is outside the map' do
      expect(build(:position, token: token, map: map, y: 10).valid?).to be false
    end
    it 'returns the correct message when bounds are not respected' do
      position = build(:position, token: token, map: map, y: -1)
      position.validate
      expect(position.errors.messages[:y]).to eq ['bounds']
    end
  end
end