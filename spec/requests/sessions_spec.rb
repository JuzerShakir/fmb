require 'rails_helper'

RSpec.describe "Sessions", type: :request do

    # * NEW
    context "GET new" do
        before { get login_path }

        it "should render a new template with 200 status code" do
            expect(response).to render_template(:new)
            expect(response).to have_http_status(:ok)
        end
    end
end