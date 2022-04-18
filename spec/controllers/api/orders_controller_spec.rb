require 'rails_helper'
require 'deep_clone'

RSpec.describe Api::OrdersController do
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end

  describe 'POST #create' do
    before :all do
      category = create(:category)

      @menus = [
        create(
          :menu, 
          name: "Nasi Pecel", 
          price: 10000, 
          description: "Nasi dengan pecel",
          categories: [category] 
        ),
        create(
          :menu, 
          name: "Nasi Goreng", 
          price: 15000, 
          description: "Nasi yang digoreng",
          categories: [category] 
        ),
      ]

      @params = { 
        menus: [
          {
            menu_id: @menus[0].id,
            quantity: 2
          },
          {
            menu_id: @menus[1].id,
            quantity: 1
          },
        ],
        customer: {
          name: "John Doe",
          email: "john@gmail.com",
        }
      }
    end

    context "with valid attributes" do
      it "insert new order to the database" do
        initial_count = Order.count

        post :create, params: @params, as: :json

        final_count = Order.count

        expect(final_count - initial_count).to eq(1)

        order = Order.last
        total_price = @params[:menus].inject(0) { |sum, menu| sum + menu[:quantity] * (@menus.find {|i| i.id == menu[:menu_id]}).price }

        expect(order.total_price).to eq total_price
        expect(order.status).to eq 'new'
        expect(order.order_menus[0].quantity).to eq @params[:menus][0][:quantity]
        expect(order.order_menus[1].quantity).to eq @params[:menus][1][:quantity]
        expect(order.order_menus[0].total_price).to eq @params[:menus][0][:quantity] * @menus[0].price
        expect(order.order_menus[1].total_price).to eq @params[:menus][1][:quantity] * @menus[1].price
        expect(order.customer.name).to eq @params[:customer][:name]
        expect(order.customer.email).to eq @params[:customer][:email]
      end

      it "return category object" do
        post :create, params: @params, as: :json

        expect(response.body).to eq Order.last.to_json
      end
    end

    context "with invalid attributes" do
      it "does not save when menu id invalid" do
        params = DeepClone.clone @params
        params[:menus][0][:menu_id] = 999
        initial_count = Order.count

        post :create, params: params, as: :json

        final_count = Order.count

        expect(final_count - initial_count).to eq(0)
        expect(response.body).to eq ({ message: "Menu not found" }.to_json)
        expect(response.status).to eq 404
      end

      it "does not save when parameter missing" do
        params = DeepClone.clone @params
        params[:menus] = nil
        initial_count = Order.count

        post :create, params: params, as: :json

        final_count = Order.count

        expect(final_count - initial_count).to eq(0)
        expect(response.body).to eq ({ message: "Parameter missing" }.to_json)
        expect(response.status).to eq 422
      end
    end
  end

  describe 'PUT #update' do
    before :each do
      @order = create(:order, :with_order_menus, :with_customer)
    end

    context "with valid attributes" do
      it "update order status paid in database" do
        initial_count = Order.where(status: "paid").count()

        put :update, params: { id: @order.id, status: 'paid' }, as: :json

        final_count = Order.where(status: "paid").count()

        expect(final_count - initial_count).to eq 1
        expect(response.body).to eq ({ message: "Order updated" }.to_json)
      end

      it "update order status canceled in database" do
        initial_count = Order.where(status: "canceled").count()

        put :update, params: { id: @order.id, status: 'canceled' }, as: :json

        final_count = Order.where(status: "canceled").count()

        expect(final_count - initial_count).to eq 1
        expect(response.body).to eq ({ message: "Order updated" }.to_json)
      end
    end

    context "with invalid attributes" do
      it "does not update when order id invalid" do
        initial_count = Order.where(status: "paid").count()

        put :update, params: { id: 999, status: 'paid' }, as: :json

        final_count = Order.where(status: "paid").count()

        expect(final_count - initial_count).to eq 0
        expect(response.body).to eq ({ message: "Order not found" }.to_json)
        expect(response.status).to eq 404
      end

      it "does not update when status invalid" do
        put :update, params: { id: @order.id, status: 'test' }, as: :json

        expect(response.body).to eq ({ message: "Validation failed: Status is not included in the list" }.to_json)
        expect(response.status).to eq 422
      end
    end
  end

  describe 'GET #index_revenue' do
    before :all do
      @orders = [
        create(:order, :with_order_menus, :with_customer, total_price: 15000, status: 'paid'),
        create(:order, :with_order_menus, :with_customer, total_price: 20000, status: 'paid'),
        create(:order, :with_order_menus, :with_customer, total_price: 25000, status: 'paid', created_at: Time.now - 3.day),
        create(:order, :with_order_menus, :with_customer, total_price: 30000, status: 'paid', created_at: Time.now - 5.day),
      ]
    end

    it "populates an array of all orders today and total revenue" do 
      get :index_revenue

      result = JSON.parse(response.body)
      expect(result["total_revenue"]).to eq(@orders[0].total_price + @orders[1].total_price)
      expect(result["orders"][0]["id"]).to eq(@orders[0].id)
      expect(result["orders"][1]["id"]).to eq(@orders[1].id)
      expect(result["orders"].length).to eq(2)
    end

    it "populates an array of all orders and total revenue with email" do 
      get :index_revenue, params: { email: @orders[0].customer.email }

      result = JSON.parse(response.body)
      expect(result["total_revenue"]).to eq(@orders[0].total_price)
      expect(result["orders"][0]["id"]).to eq(@orders[0].id)
    end

    it "populates an array of all orders and total revenue with max price" do
      get :index_revenue, params: { max_price: 28000 }

      result = JSON.parse(response.body)
      expect(result["total_revenue"]).to eq(@orders[0].total_price + @orders[1].total_price + @orders[2].total_price)
      expect(result["orders"][0]["id"]).to eq(@orders[0].id)
      expect(result["orders"][1]["id"]).to eq(@orders[1].id)
      expect(result["orders"][2]["id"]).to eq(@orders[2].id)
      expect(result["orders"].length).to eq(3)
    end

    it "populates an array of all orders and total revenue with min price" do
      get :index_revenue, params: { min_price: 23000 }

      result = JSON.parse(response.body)
      expect(result["total_revenue"]).to eq(@orders[2].total_price + @orders[3].total_price)
      expect(result["orders"][0]["id"]).to eq(@orders[2].id)
      expect(result["orders"][1]["id"]).to eq(@orders[3].id)
      expect(result["orders"].length).to eq(2)
    end

    it "populates an array of all orders and total revenue with range price" do
      get :index_revenue, params: { min_price: 23000, max_price: 28000 }

      result = JSON.parse(response.body)
      expect(result["total_revenue"]).to eq(@orders[2].total_price)
      expect(result["orders"][0]["id"]).to eq(@orders[2].id)
      expect(result["orders"].length).to eq(1)
    end

    it "populates an array of all orders and total revenue with max date" do
      get :index_revenue, params: { max_date: (Time.now - 1.day).strftime("%Y-%m-%d") }

      result = JSON.parse(response.body)
      expect(result["total_revenue"]).to eq(@orders[2].total_price + @orders[3].total_price)
      expect(result["orders"][0]["id"]).to eq(@orders[2].id)
      expect(result["orders"][1]["id"]).to eq(@orders[3].id)
      expect(result["orders"].length).to eq(2)
    end

    it "populates an array of all orders and total revenue with min date" do
      get :index_revenue, params: { min_date: (Time.now - 4.day).strftime("%Y-%m-%d") }

      result = JSON.parse(response.body)
      expect(result["total_revenue"]).to eq(@orders[0].total_price + @orders[1].total_price + @orders[2].total_price)
      expect(result["orders"][0]["id"]).to eq(@orders[0].id)
      expect(result["orders"][1]["id"]).to eq(@orders[1].id)
      expect(result["orders"][2]["id"]).to eq(@orders[2].id)
      expect(result["orders"].length).to eq(3)
    end

    it "populates an array of all orders and total revenue with range date" do
      get :index_revenue, params: {
        min_date: (Time.now - 4.day).strftime("%Y-%m-%d"),
        max_date: (Time.now - 1.day).strftime("%Y-%m-%d") 
      }

      result = JSON.parse(response.body)
      expect(result["total_revenue"]).to eq(@orders[2].total_price)
      expect(result["orders"][0]["id"]).to eq(@orders[2].id)
      expect(result["orders"].length).to eq(1)
    end

    it "populates an array of all orders and total revenue with mixed parameter" do
      get :index_revenue, params: {
        min_date: (Time.now - 4.day).strftime("%Y-%m-%d"),
        max_date: (Time.now - 1.day).strftime("%Y-%m-%d"),
        email: @orders[2].customer.email,
        max_price: 30000,
        min_price: 15000
      }

      result = JSON.parse(response.body)
      expect(result["total_revenue"]).to eq(@orders[2].total_price)
      expect(result["orders"][0]["id"]).to eq(@orders[2].id)
      expect(result["orders"].length).to eq(1)
    end

    it "response with json content type" do
      get :index_revenue

      expect(response.content_type).to include 'application/json'
    end

    it "response with valid json object" do
      get :index_revenue

      expect { JSON.parse(response.body) }.not_to raise_error
    end
  end
end
