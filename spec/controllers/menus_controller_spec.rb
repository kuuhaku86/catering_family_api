RSpec.describe MenusController do
  describe 'GET #index' do
    it "renders the :index template" do
      get :index, params: { letter: 'N' }
      expect(response).to render_template :index
    end
  end
end