require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe '.factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:customer)).to be_valid
    end
  end

  describe '.validations' do
    context 'with valid attributes' do
      it 'is valid with a name and a email' do
        expect(FactoryBot.build(:customer)).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'invalid without name' do
        customer = FactoryBot.build(:invalid_customer)
        customer.valid?
        expect(customer.errors[:name]).to include("can't be blank")
      end
    end
  end
end
