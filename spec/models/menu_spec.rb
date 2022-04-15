require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe '.factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:menu)).to be_valid
    end
  end

  describe '.validations' do
    context 'with valid attributes' do
      it 'is valid with a name, price, and description' do
        expect(FactoryBot.build(:menu)).to be_valid
      end
    end
  end
end
