require 'rails_helper'

RSpec.describe OrderMenu, type: :model do
  describe '.factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:order_menu)).to be_valid
    end
  end

  describe '.validations' do
    context 'with valid attributes' do
      it 'is valid with a quatity and a total_price' do
        expect(FactoryBot.build(:order_menu)).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'invalid without quantity' do
        order_menu = FactoryBot.build(:invalid_order_menu)

        order_menu.valid?

        expect(order_menu.errors[:quantity]).to include("can't be blank")
      end

      it 'invalid when quantity less than 0' do
        order_menu = FactoryBot.build(:invalid_order_menu, quantity: -1)

        order_menu.valid?

        expect(order_menu.errors[:quantity]).to include("must be greater than 0")
      end

      it 'invalid when total_price less than 0' do
        order_menu = FactoryBot.build(:invalid_order_menu, total_price: -1)

        order_menu.valid?

        expect(order_menu.errors[:total_price]).to include("must be greater than 0")
      end

      it 'invalid without total_price' do
        order_menu = FactoryBot.build(:invalid_order_menu)

        order_menu.valid?

        expect(order_menu.errors[:total_price]).to include("can't be blank")
      end
    end
  end

  describe '.associations' do
    context 'with valid attributes' do
      it 'is valid with order' do
        expect(FactoryBot.build(:order_menu)).to be_valid
      end

      it 'is valid with menu' do
        expect(FactoryBot.build(:order_menu)).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'invalid without order' do
        order_menu = FactoryBot.build(:invalid_order_menu)

        order_menu.valid?

        expect(order_menu.errors[:order]).to include("can't be blank")
      end

      it 'invalid without menu' do
        order_menu = FactoryBot.build(:invalid_order_menu)

        order_menu.valid?

        expect(order_menu.errors[:menu]).to include("can't be blank")
      end
    end
  end
end
