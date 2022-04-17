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
        params = {}
        params[:id] = @menu.id
        params[:price] = @params[:price]

        put :update, params: params

        menu = Menu.last

        expect(menu.name).to eq @menu.name
        expect(menu.description).to eq @menu.description
        expect(menu.price).to eq @params[:price]
        expect(menu.categories[0].id).to eq @menu.categories[0].id
        expect(menu.categories[1].id).to eq @menu.categories[1].id
      end

      it "update the description only menu in the database" do
        params = {}
        params[:id] = @menu.id
        params[:description] = @params[:description]

        put :update, params: params

        menu = Menu.last

        expect(menu.name).to eq @menu.name
        expect(menu.description).to eq @params[:description]
        expect(menu.price).to eq @menu.price
        expect(menu.categories[0].id).to eq @menu.categories[0].id
        expect(menu.categories[1].id).to eq @menu.categories[1].id
      end

      it "update the categories only menu in the database" do
        params = {}
        params[:id] = @menu.id
        params[:categories] = @params[:categories]

        put :update, params: params

        menu = Menu.last

        expect(menu.name).to eq @menu.name
        expect(menu.description).to eq @menu.description
        expect(menu.price).to eq @menu.price
        expect(menu.categories[0].id).to eq @params[:categories][0]
        expect(menu.categories[1].id).to eq @params[:categories][1]
      end

      it "update price not affect orders_menus" do
        order = create(:order, :with_customer)
        order_menu = create(
          :order_menu, 
          quantity: 3,
          total_price: 3 * @menu.price,
          menu: @menu,
          order: order
        )
        params = {}
        params[:id] = @menu.id
        params[:price] = @params[:price]

        put :update, params: params

        menu = Menu.last
        order_menu = OrderMenu.last

        expect(menu.price).to eq @params[:price]
        expect(order_menu.total_price).to eq(3 * @menu.price)
      end

      it "return success message" do
        params = DeepClone.clone @params
        params[:id] = @menu.id

        put :update, params: params

        expect(response.body).to eq ({ message: "Menu updated" }.to_json)
      end
    end

    context "with invalid attributes" do
      it "does not save when id menu not found" do
        params = DeepClone.clone @params
        params[:id] = 999

        put :update, params: params

        expect(response.body).to eq ({ message: "Menu not found" }.to_json)
      end

      it "does not save the invalid attributes menu to the database" do
        params = {}
        params[:id] = @menu.id

        put :update, params: params

        expect(response.body).to eq ({ message: "Parameter missing" }.to_json)
      end

      it "does not save duplicate name" do
        create(:menu, name: @params[:name], categories:[@categories[0]])

        params = DeepClone.clone @params
        params[:id] = @menu.id

        put :update, params: params

        expect(response.body).to eq ({ message: "Name has already been taken" }.to_json)
      end

      it "does not save price < 0.01" do
        params = DeepClone.clone @params
        params[:id] = @menu.id
        params[:price] = 0.001

        put :update, params: params

        expect(response.body).to eq ({ message: "Price must be greater than or equal to 0.01" }.to_json)
      end

      it "does not save description exceed 150 characters" do
        params = DeepClone.clone @params
        params[:id] = @menu.id
        params[:description] = "a" * 151

        put :update, params: params

        expect(response.body).to eq ({ message: "Description is too long (maximum is 150 characters)" }.to_json)
      end
    end
  end

  describe 'GET #index' do
    before :all do
      @categories = [
        create(:category, name: "CategoryMenu6"),
        create(:category, name: "CategoryMenu7"),
        create(:category, name: "CategoryMenu8"),
      ]

      @menus = [
        create(
          :menu, 
          name: "Nasi Bungkus", 
          price: 10000, 
          description: "Nasi yang dibungkus",
          categories: [@categories[0], @categories[1]] 
        ),
        create(
          :menu, 
          name: "Nasi Tumpeng", 
          price: 20000, 
          description: "Nasi yang ditumpeng",
          categories: [@categories[0], @categories[2]] 
        ),
        create(
          :menu, 
          name: "Nasi Jagung", 
          price: 15000, 
          description: "Nasi dari jagung",
          categories: [@categories[1], @categories[2]] 
        ),
      ]
    end

    before :each do
    end

    it "populates an array of all menus" do 
      get :index

      expect(response.body).to eq(@menus.to_json)
    end

    it "populates an array of all menus that not soft deleted" do 
      create(
        :menu, 
        name: "Nasi Ubi", 
        price: 15000, 
        description: "Nasi dari jagung",
        categories: [@categories[1], @categories[2]],
        soft_deleted: true
      )

      get :index

      expect(response.body).to eq(@menus.to_json)
    end

    it "populates menus that related with the category" do
      get :index, params: { category_id: @categories[1].id }

      expect(response.body).to eq([@menus[0], @menus[2]].to_json)
    end

    it "response with json content type" do
      get :index

      expect(response.content_type).to include 'application/json'
    end

    it "response with valid json object" do
      get :index

      expect { JSON.parse(response.body) }.not_to raise_error
    end
  end

  describe 'DELETE #destroy' do
    before :all do
      @categories = [
        create(:category, name: "CategoryMenu9"),
      ]

      @menu = create(
        :menu, 
        name: "Nasi Tiwul", 
        price: 15000, 
        description: "Nasi dari tiwul",
        categories: [@categories[0]]
      )
    end

    context "with valid attributes" do
      it "soft delete the menu in the database" do
        status_before = @menu.soft_deleted

        delete :destroy, params: { id: @menu.id }

        expect(status_before).to eq false
        expect(Menu.find_by(id: @menu.id).soft_deleted).to eq true
      end

      it "return success message" do
        delete :destroy, params: { id: @menu.id }

        expect(response.body).to eq ({ message: "Menu deleted" }.to_json)
        expect(response.status).to eq 200
      end
    end

    context "with invalid attributes" do
      it "does not delete when menu not found" do
        delete :destroy, params: { id: 999 }

        expect(response.body).to eq ({ message: "Menu not found" }.to_json)
        expect(response.status).to eq 404
      end
    end
  end
end