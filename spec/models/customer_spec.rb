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
  end
end
