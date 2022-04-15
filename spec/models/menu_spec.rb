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

    context 'with invalid attributes' do
      it 'invalid without name' do
        menu = FactoryBot.build(:invalid_menu)
        menu.valid?
        expect(menu.errors[:name]).to include("can't be blank")
      end
    end
  end
end
