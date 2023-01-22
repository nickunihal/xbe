require 'rails_helper'

RSpec.describe "Invoices", type: :request do
  describe "GET /invoices" do
    it "renders invoices index page" do
      get invoices_index_path
      expect(response).to have_http_status(200)
    end
  end
end
