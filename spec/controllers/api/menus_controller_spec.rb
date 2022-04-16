require 'rails_helper'

RSpec.describe Api::MenusController do
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end

  describe 'POST #create' do
    context "with valid attributes" do
      before :all do
        @categories = [
          create(:category, name: "CategoryMenu1"),
          create(:category, name: "CategoryMenu2")
        ]

        @params = { 
          menu: {
            name: 'Nasi Kuning',
            description: 'Nasi dengan warna kuning',
            price: 10000,
            categories: [
              @categories[0].id,
              @categories[1].id,
            ]
          } 
        }
      end


      it "saves the new menu in the database" do
        initial_count = Menu.count

        post :create, params: @params

        final_count = Menu.count

        expect(final_count - initial_count).to eq(1)

        menu = Menu.last

        expect(menu.name).to eq 'Nasi Kuning'
        expect(menu.description).to eq 'Nasi dengan warna kuning'
        expect(menu.price).to eq 10000
        expect(menu.categories[0].id).to eq @categories[0].id 
        expect(menu.categories[1].id).to eq @categories[1].id 
      end

      it "return category object" do
      end
    end

    context "with invalid attributes" do
      it "does not save the invalid attributes menu to the database" do
      end

      it "does not save duplicate name" do
      end

      it "does not save price < 0.01" do
      end

      it "does not save description exceed 150 characters" do
      end

      it "does not save if don't have any category" do
      end
    end
  end
end