RSpec.describe OrdersController do
  describe 'GET #index' do
    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #revenue' do
    it "renders the :revenue template" do
      get :revenue
      expect(response).to render_template :revenue
    end
  end
end
