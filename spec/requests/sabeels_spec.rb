require 'rails_helper'

RSpec.describe "Sabeels", type: :request do
  context "GET new" do
    before { get new_sabeel_path }

    it "works" do
      expect(response).to have_http_status(:ok)
    end
  end
end
