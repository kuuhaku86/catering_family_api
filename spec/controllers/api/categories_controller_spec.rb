require 'rails_helper'

RSpec.describe Api::CategoriesController do
  describe 'GET #index' do
    before :all do
      @category1 = create(:category)
      @category1 = create(:category)
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
      it "populates an array of all categories" do 
      end

      it "response with json content type" do
      end

      it "response with valid json object" do
      end
    end
  end
end