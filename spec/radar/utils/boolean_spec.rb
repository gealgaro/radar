RSpec.describe Boolean do
  describe 'TrueClass' do
    it 'identifies an instance of TrueClass as a Boolean' do
      expect(true).to be_a Boolean
    end
  end

  describe 'FalseClass' do
    it 'identifies an instance of FalseClass as a Boolean' do
      expect(false).to be_a Boolean
    end
  end
end
