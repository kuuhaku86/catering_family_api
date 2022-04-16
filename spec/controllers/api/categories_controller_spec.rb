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
      @category1 = create(:category)
      @category2 = create(:category)
      @categories = [@category1, @category2]
    end

    context 'with params[:id]' do
      subject { @category1 }

      it "populates an category object" do
        get :index, params: { id: @category1.id }

        expect(response.body).to eq @category1.to_json
      end

      it "response with json content type" do
        get :index, params: { id: @category1.id }

        expect(response.content_type).to include 'application/json'
      end

      it "response with valid json object" do
        get :index, params: { id: @category1.id }

        expect { JSON.parse(response.body) }.not_to raise_error
      end
    end

    context 'without params[:id]' do
      subject { @categories }

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
      it "does not save the new category in the database" do
        initial_count = Category.count

        post :create, params: {}

        final_count = Category.count

        expect(final_count - initial_count).to eq(0)
      end

      it "does not save duplicate categories" do
      end

      it "return error message" do
      end
    end
  end
end