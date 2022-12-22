require 'rails_helper'

RSpec.describe "Sabeels", type: :request do

  context "GET new" do
    before { get new_sabeel_path }

    it "should return an 200 (OK) status code" do
      expect(response).to have_http_status(:ok)
    end

    it { should render_template(:new) }
  end
end
