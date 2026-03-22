require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  let!(:user_profile) do
    create(:profile, user: user, display_name: "MyProfile")
  end

  let!(:other_profile) do
    create(:profile, user: other_user, display_name: "OtherProfile")
  end

  describe "POST /likes" do
    context "when user is not signed in" do
      it "redirects to sign in" do
        post public_profile_like_path(other_profile)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in" do
      before { sign_in user }

      it "creates a like" do
        expect do
          post public_profile_like_path(other_profile)
        end.to change(Like, :count).by(1)

        expect(response).to redirect_to(public_profile_path(other_profile))
        expect(flash[:notice]).to eq("Liked successfully.")
      end

      it "does not allow liking self" do
        expect do
          post public_profile_like_path(user_profile)
        end.not_to change(Like, :count)

        expect(response).to redirect_to(public_profile_path(user_profile))
        expect(flash[:alert]).to be_present
      end

      it "does not allow duplicate likes" do
        create(:like, liker: user, liked: other_user)

        expect do
          post public_profile_like_path(other_profile)
        end.not_to change(Like, :count)

        expect(response).to redirect_to(public_profile_path(other_profile))
        expect(flash[:alert]).to be_present
      end
    end

    context "when signed in without a profile" do
      let(:user_without_profile) { create(:user) }

      before { sign_in user_without_profile }

      it "redirects to profile creation" do
        expect do
          post public_profile_like_path(other_profile)
        end.not_to change(Like, :count)

        expect(response).to redirect_to(new_profile_path)
        expect(flash[:alert]).to be_present
      end
    end
  end
end
