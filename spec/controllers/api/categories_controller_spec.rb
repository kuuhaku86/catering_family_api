require 'rails_helper'

RSpec.describe Api::CategoriesController do
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end

  describe 'GET #index' do
    before :all do
      @category1 = create(:category, name: "Category1")
      @category2 = create(:category, name: "Category2")
      @categories = [@category1, @category2]
    end

    it "populates an array of all categories" do 
      get :index

      expect(response.body).to eq(@categories.to_json)
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

  describe 'GET #show' do
    before :all do
      @category = create(:category, name: "Category3")
    end

    context "with valid id" do
      it "populates an category object" do
        get :show, params: { id: @category.id }

        expect(response.body).to eq @category.to_json
      end

      it "response with json content type" do
        get :show, params: { id: @category.id }

        expect(response.content_type).to include 'application/json'
      end

      it "response with valid json object" do
        get :show, params: { id: @category.id }

        expect { JSON.parse(response.body) }.not_to raise_error
      end
    end

    context "with invalid id" do
      it "return error message" do
        get :show, params: { id: 99 }

        expect(response.body).to eq({ message: "Category not found" }.to_json)
      end

      it "return status 404" do
        get :show, params: { id: 99 }

        expect(response.status).to eq 404
      end
    end
  end

  describe 'POST #create' do
    before :all do
      @params = { 
        category: {
          name: 'Beverages'
        } 
      }
    end

    context "with valid attributes" do

      it "saves the new category in the database" do
        initial_count = Category.count

        post :create, params: @params

        final_count = Category.count

        expect(final_count - initial_count).to eq(1)
        expect(Category.last.name).to eq 'Beverages'
      end

      it "return category object" do
        post :create, params: @params

        expect(response.body).to eq Category.last.to_json
      end
    end

    context "with invalid attributes" do
      it "does not save the invalid attributes category to the database" do
        initial_count = Category.count

        post :create, params: {}

        final_count = Category.count

        expect(final_count - initial_count).to eq(0)
        expect(response.body).to eq({ message: "Parameter missing" }.to_json)
        expect(response.status).to eq 422
      end

      it "does not save duplicate categories" do
        FactoryBot.create(:category, name: 'Beverages')

        initial_count = Category.count

        post :create, params: @params

        final_count = Category.count

        expect(final_count - initial_count).to eq(0)
        expect(response.body).to eq({ message: "Name has already been taken" }.to_json)
        expect(response.status).to eq 422
      end
    end
  end

  describe 'PUT #update' do
    before :all do
      @category = create(:category, name: "Category4")
      @params = { 
        id: @category.id,
        name: "Food"
      }
    end

    context "with valid attributes" do
      it "update category in the database" do
        initial_count = Category.count

        put :update, params: @params

        final_count = Category.count

        expect(final_count - initial_count).to eq(0)
        expect(Category.last.name).to eq 'Food'
      end

      it "return category object" do
        put :update, params: @params

        result = JSON.parse(response.body)

        expect(result["name"]).to eq Category.last.name
        expect(response.status).to eq 200
      end
    end

    context "with invalid attributes" do
      it "does not save when id invalid" do
        put :update, params: {
          id: 99
        }

        expect(response.body).to eq({ message: "Category not found" }.to_json)
        expect(response.status).to eq 404
      end

      it "does not save when param name not exist" do
      end

      it "does not save duplicate categories" do
      end
    end
  end
end