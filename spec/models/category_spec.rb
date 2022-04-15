require 'rails_helper'

RSpec.describe Category, type: :model do
  describe '.factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:category)).to be_valid
    end
  end

  describe '.validations' do
    context 'with valid attributes' do
      it 'is valid with a name' do
        expect(FactoryBot.build(:category)).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'invalid without name' do
        category = FactoryBot.build(:invalid_category)
        category.valid?
        expect(category.errors[:name]).to include("can't be blank")
      end
    end
  end
end
