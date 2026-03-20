require "rails_helper"

RSpec.describe "PublicProfiles", type: :request do
  let(:user)       { create(:user) }
  let(:other_user) { create(:user) }
  let!(:other_profile) { create(:profile, user: other_user, display_name: "OtherProfile") }

  describe "GET /profiles" do
    context "when the user is not signed in" do
      it "redirects the user to sign in" do
        get public_profiles_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when the user is signed in without a profile" do
      before { sign_in user }

      it "redirects the user to profile creation" do
        get public_profiles_path
        expect(response).to redirect_to new_profile_path
      end
    end

    context "when the user is signed in with a profile" do
      before { sign_in user }
      let!(:profile) { create(:profile, user: user, display_name: "MyProfile") }

      it "allows the user to browse profiles" do
        get public_profiles_path
        expect(response).to have_http_status(:ok)
      end

      it "includes other user's profile in the index" do
        get public_profiles_path
        expect(response.body).to include("OtherProfile")
      end

      it "does not show the current user's own profile in the index" do
        get public_profiles_path
        expect(response.body).not_to include("MyProfile")
      end
    end
  end

  describe "GET /profiles/:id" do
    context "when the user is not signed in" do
      it "redirects the user to sign in" do
        get public_profile_path(other_profile)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when the user is signed in without profile" do
      before { sign_in user }

      it "redirect the user to profile creation" do
        get public_profile_path(other_profile)
        expect(response).to redirect_to new_profile_path
      end
    end

    context "when the user signed in with a profile" do
      before { sign_in user }
      let!(:profile) { create(:profile, user: user, display_name: "MyProfile") }

      it "allows the user to visit other user's profile" do
        get public_profile_path(other_profile)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("OtherProfile")
      end

      it "returns 404 when profile is not found" do
        get public_profile_path(id: 999_999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
