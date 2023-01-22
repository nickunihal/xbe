require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe "GET /items" do
    it "renders items index page" do
      get items_index_path
      expect(response).to have_http_status(200)
    end
  end



end
