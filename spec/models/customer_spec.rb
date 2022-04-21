require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe '.factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:customer, :with_orders)).to be_valid
    end
  end

  describe '.validations' do
    context 'with valid attributes' do
      it 'is valid with a email' do
        expect(FactoryBot.build(:customer, :with_orders)).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'invalid without email' do
        customer = FactoryBot.build(:invalid_customer)
        customer.valid?
        expect(customer.errors[:email]).to include("can't be blank")
      end

      it 'invalid with invalid email' do
        customer = FactoryBot.build(:invalid_customer, email: 'halo@gigih')
        customer.valid?
        expect(customer.errors[:email]).to include("is invalid")
      end

      it 'invalid with duplicate email' do
        customer1 = FactoryBot.create(:customer, :with_orders, email: 'test@test.com')
        customer2 = FactoryBot.build(:invalid_customer, email: 'test@test.com')

        customer2.valid?

        expect(customer2.errors[:email]).to include("has already been taken")
      end
    end
  end

  describe '.associations' do
    context 'with valid attributes' do
      it 'is valid with orders' do
        expect(FactoryBot.build(:customer, :with_orders)).to be_valid
      end
    end
  end
end
