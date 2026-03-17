require "rails_helper"

RSpec.describe "Home", type: :request do
  describe "GET /" do
    context "when user is not signed in" do
      it "returns a successful response" do
        get root_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "when user is signed in in without a profile" do
      let(:user) { create(:user) }

      before { sign_in user }

      it "redirects to new profile path" do
        get root_path
        expect(response).to redirect_to(new_profile_path)
      end
    end

    context "when user is signed in with a profile" do
      let(:user) { create(:user) }

      before do
        sign_in user
        create(:profile, user: user)
      end

      it "returns a successful response" do
        get root_path
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
