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

    context 'with invalid attributes' do
      it 'invalid without total_price' do
        order = FactoryBot.build(:invalid_order)
        order.valid?
        expect(order.errors[:total_price]).to include("can't be blank")
      end

      it 'invalid without status' do
        order = FactoryBot.build(:invalid_order)
        order.valid?
        expect(order.errors[:status]).to include("can't be blank")
      end
    end
  end

  describe '.associations' do
    context 'with valid attributes' do
      it 'is valid with customer' do
        expect(FactoryBot.build(:order)).to be_valid
      end
    end
  end
end
