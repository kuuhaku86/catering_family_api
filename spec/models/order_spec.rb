require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '.factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:order)).to be_valid
    end
  end

  describe '.validations' do
    context 'with valid attributes' do
      it 'is valid with a total_price and a status' do
        expect(FactoryBot.build(:order)).to be_valid
      end
    end
  end
end
