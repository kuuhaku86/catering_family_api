RSpec.describe MenusController do
  describe 'GET #index' do
    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #index_ownner' do
    it "renders the :index_owner template" do
      get :index_owner
      expect(response).to render_template :index_owner
    end
  end
end