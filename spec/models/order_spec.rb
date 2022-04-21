require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '.factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:order, :with_order_menus, :with_customer)).to be_valid
    end
  end

  describe '.validations' do
    context 'with valid attributes' do
      it 'is valid with a total_price and a status' do
        expect(FactoryBot.build(:order, :with_order_menus, :with_customer)).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'invalid without total_price' do
        order = FactoryBot.build(:invalid_order)

        order.valid?

        expect(order.errors[:total_price]).to include("can't be blank")
      end

      it 'invalid when total_price less than 1' do
        order = FactoryBot.build(:invalid_order, total_price: 0)

        order.valid?

        expect(order.errors[:total_price]).to include("must be greater than 0")
      end

      it 'invalid without status' do
        order = FactoryBot.build(:invalid_order)

        order.valid?

        expect(order.errors[:status]).to include("can't be blank")
      end

      it 'invalid when status is not included in the list' do
        order = FactoryBot.build(:invalid_order, status: "test")

        order.valid?

        expect(order.errors[:status]).to include("is not included in the list")
      end
    end
  end

  describe '.associations' do
    context 'with valid attributes' do
      it 'is valid with customer' do
        expect(FactoryBot.build(:order, :with_order_menus, :with_customer)).to be_valid
      end

      it 'is valid with order_menus' do
        expect(FactoryBot.build(:order, :with_order_menus, :with_customer)).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'invalid without customer' do
        order = FactoryBot.build(:invalid_order)

        order.valid?

        expect(order.errors[:customer]).to include("can't be blank")
      end
    end
  end
end
