RSpec.describe Core::Models::Campaigns::Map do
  let!(:account) { create(:account) }
  let!(:campaign) { create(:campaign, creator: account) }

  describe :height do
    it 'has a default height set at creation' do
      expect(build(:map, campaign: campaign).height).to be 1
    end
    it 'has a height when given by user' do
      expect(build(:map, campaign: campaign, height: 10).height).to be 10
    end
    describe 'negative or zero value error' do
      let!(:map) { build(:map, campaign: campaign, height: 0) }
      it 'does not validate when given inferior to zero' do
        expect(map.valid?).to be false
      end
      it 'returns the correct message' do
        map.validate
        expect(map.errors.messages[:height]).to eq(['minimum'])
      end
    end
  end

  describe :width do
    it 'has a default width set at creation' do
      expect(build(:map, campaign: campaign).width).to be 1
    end
    it 'has a width when given by user' do
      expect(build(:map, campaign: campaign, width: 10).width).to be 10
    end
    describe 'negative or zero value error' do
      let!(:map) { build(:map, campaign: campaign, width: 0) }
      it 'does not validate when given inferior to zero' do
        expect(map.valid?).to be false
      end
      it 'returns the correct message' do
        map.validate
        expect(map.errors.messages[:width]).to eq(['minimum'])
      end
    end
  end
end