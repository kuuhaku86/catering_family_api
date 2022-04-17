require 'rails_helper'
require 'deep_clone'

RSpec.describe Api::MenusController do
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end

  describe 'POST #create' do
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

    context "with valid attributes" do
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

      it "return menu object" do
        post :create, params: @params

        expect(response.body).to eq Menu.last.to_json
      end
    end

    context "with invalid attributes" do
      it "does not save the invalid attributes menu to the database" do
        initial_count = Menu.count

        post :create, params: { menu: {} }

        final_count = Menu.count

        expect(final_count - initial_count).to eq(0)
        expect(response.body).to eq({ message: "Parameter missing" }.to_json)
        expect(response.status).to eq 422
      end

      it "does not save duplicate name" do
        create(:menu, name: "Nasi Kuning", categories:[@categories[0]])

        initial_count = Menu.count

        post :create, params: @params

        final_count = Menu.count

        expect(final_count - initial_count).to eq(0)
        expect(response.body).to eq({ message: "Name has already been taken" }.to_json)
        expect(response.status).to eq 422
      end

      it "does not save price < 0.01" do
        params = DeepClone.clone @params
        params[:menu][:price] = 0.001
        initial_count = Menu.count

        post :create, params: params

        final_count = Menu.count

        expect(final_count - initial_count).to eq(0)
        expect(response.body).to eq({ message: "Price must be greater than or equal to 0.01" }.to_json)
        expect(response.status).to eq 422
      end

      it "does not save description exceed 150 characters" do
        params = DeepClone.clone @params
        params[:menu][:description] = "a" * 151
        initial_count = Menu.count

        post :create, params: params

        final_count = Menu.count

        expect(final_count - initial_count).to eq(0)
        expect(response.body).to eq({ message: "Description is too long (maximum is 150 characters)" }.to_json)
        expect(response.status).to eq 422
      end

      it "does not save if don't have any category" do
        params = DeepClone.clone @params
        params[:menu][:categories] = []
        initial_count = Menu.count

        post :create, params: params

        final_count = Menu.count

        expect(final_count - initial_count).to eq(0)
        expect(response.body).to eq({ message: "Categories can't be blank" }.to_json)
        expect(response.status).to eq 422
      end
    end
  end

  describe 'PUT #update' do
    before :all do
      @categories = [
        create(:category, name: "CategoryMenu3"),
        create(:category, name: "CategoryMenu4"),
        create(:category, name: "CategoryMenu5"),
      ]

      @params = { 
        name: 'Nasi Uduk',
        description: 'Nasi yang mantab',
        price: 20000,
        categories: [
          @categories[0].id,
          @categories[2].id,
        ]
      }
    end

    before :each do
      @menu = create(
        :menu, 
        name: "Nasi Kucing", 
        price: 10000, 
        description: "Nasi dengan warna kuning",
        categories: [@categories[0], @categories[1]] 
      )
    end

    context "with valid attributes" do
      it "update the all attributes menu in the database" do
        params = DeepClone.clone @params
        params[:id] = @menu.id

        initial_count = Menu.count

        put :update, params: params

        final_count = Menu.count

        expect(final_count - initial_count).to eq(0)

        menu = Menu.last

        expect(menu.name).to eq @params[:name]
        expect(menu.description).to eq @params[:description]
        expect(menu.price).to eq @params[:price]
        expect(menu.categories[0].id).to eq @params[:categories][0]
        expect(menu.categories[1].id).to eq @params[:categories][1]
      end

      it "update the name only menu in the database" do
        params = {}
        params[:id] = @menu.id
        params[:name] = @params[:name]

        put :update, params: params

        menu = Menu.last

        expect(menu.name).to eq @params[:name]
        expect(menu.description).to eq @menu.description
        expect(menu.price).to eq @menu.price
        expect(menu.categories[0].id).to eq @menu.categories[0].id
        expect(menu.categories[1].id).to eq @menu.categories[1].id
      end

      it "update the price only menu in the database" do
      end

      it "update the description only menu in the database" do
      end

      it "update the category only menu in the database" do
      end

      it "update price not affect orders_menus" do
      end

      it "return menu object" do
      end
    end

    context "with invalid attributes" do
      it "does not save when id menu not found" do
      end

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