require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the Api::CategoriesHelper. For example:
#
# describe Api::CategoriesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe Api::CategoriesHelper, type: :helper do
  describe 'GET #index' do
    context 'with params[:id]' do
      it "populates an category object" do
      end

      it "response with json content type" do
      end

      it "response with valid json object" do
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
