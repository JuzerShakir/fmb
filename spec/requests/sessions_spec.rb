require "rails_helper"

RSpec.describe "Session request - session value is 👉", type: :request do
  before do
    @password = Faker::Internet.password(min_length: 6, max_length: 72)
  end

  # * NULL
  context "'null' CAN access" do
    # * NEW
    context "GET new" do
      before { get login_path }

      it "should render a new template with 200 status code" do
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  # * NOT NULL
  context "NOT 'null' CANNOT access" do
    # * NEW
    context "GET new" do
      before do
        @user = FactoryBot.create(:user, password: @password)
        post signup_path, params: {sessions: @user.attributes.merge({password: @password})}
        get login_path
      end

      it "should redirect to root path with 302 status code" do
        expect(response).to redirect_to root_path
        expect(response).to have_http_status(:found)
      end
    end
  end
end
