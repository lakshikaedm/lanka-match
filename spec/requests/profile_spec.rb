require "rails_helper"

RSpec.describe "Profiles", type: :request do
  let(:user) { create(:user) }

  let(:valid_params) do
    {
      profile: {
        display_name: "Lakshika",
        birth_date: "1995-12-11",
        gender: "male",
        location: "Fujinomiya",
        bio: "Hello there",
        occupation: "Engineer"
      }
    }
  end

  let(:invalid_params) do
    {
      profile: {
        display_name: "",
        birth_date: "",
        gender: "",
        location: "",
        bio: "Hello there",
        occupation: "Engineer"
      }
    }
  end

  describe "GET /profile/new" do
    context "when user is not signed in" do
      it "redirects to sign in" do
        get new_profile_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is signed in" do
      before { sign_in user }

      it "returns a successful response if profile does not exist" do
        get new_profile_path
        expect(response).to have_http_status(:ok)
      end

      it "redirects to profile if profile exists" do
        create(:profile, user: user)

        get new_profile_path

        expect(response).to redirect_to(profile_path)
        expect(flash[:notice]).to eq("You already have a profile.")
      end
    end
  end

  describe "POST /profile" do
    context "when user is not signed in" do
      it "redirects to sign in" do
        post profile_path, params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is signed in" do
      before { sign_in user }

      it "creates a profile with valid params" do
        expect do
          post profile_path, params: valid_params
        end.to change(Profile, :count).by(1)

        expect(response).to redirect_to(profile_path)
        expect(flash[:notice]).to eq("Profile created successfully.")
      end

      it "does not create a profile with invalid params" do
        expect do
          post profile_path, params: invalid_params
        end.not_to change(Profile, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end

      it "redirects if profile already exists" do
        create(:profile, user: user)

        expect do
          post profile_path, params: valid_params
        end.not_to change(Profile, :count)

        expect(response).to redirect_to(profile_path)
        expect(flash[:notice]).to eq("Profile already exists.")
      end
    end
  end

  describe "GET /profile" do
    context "when user is signed in" do
      before { sign_in user }

      it "returns a successful response when profile exists" do
        create(:profile, user: user)

        get profile_path

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /profile/edit" do
    context "when user is signed in" do
      before do
        sign_in user
        create(:profile, user: user)
      end

      it "returns a successful response do" do
        get edit_profile_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PATCH /profile" do
    context "when user is signed in" do
      let!(:profile) { create(:profile, user: user, display_name: "Old Name") }

      before { sign_in user }

      it "updates the profile with valid params" do
        patch profile_path, params: {
          profile: {
            display_name: "New Name",
            location: "Tokyo"
          }
        }

        expect(response).to redirect_to(profile_path)
        expect(flash[:notice]).to eq("Profile updated successfully.")
        expect(profile.reload.display_name).to eq("New Name")
        expect(profile.location).to eq("Tokyo")
      end

      it "does not update profile with invalid params" do
        patch profile_path, params: {
          profile: {
            display_name: "",
            location: ""
          }
        }

        expect(response).to have_http_status(:unprocessable_content)
        expect(profile.reload.display_name).to eq("Old Name")
      end
    end
  end
end
