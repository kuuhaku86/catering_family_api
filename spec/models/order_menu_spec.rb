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
  end
end
