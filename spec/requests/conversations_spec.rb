require "rails_helper"

RSpec.describe "Conversations", type: :request do
  let(:user)                { create(:user) }
  let(:other_user)          { create(:user) }
  let(:another_user)        { create(:user) }
  let(:match)               { create(:match, user_one: user, user_two: other_user) }
  let(:other_match)         { create(:match, user_one: other_user, user_two: another_user) }
  let(:user_message) do
    create(
      :message,
      conversation: match.conversation,
      sender: user,
      body: "Hello",
      created_at: 2.hours.ago
    )
  end
  let(:other_user_message) do
    create(
      :message,
      conversation: match.conversation,
      sender: other_user,
      body: "Reply",
      created_at: 1.hour.ago
    )
  end

  describe "GET /conversations" do
    context "when user is not signed in" do
      it "redirects the user to sign in" do
        get conversations_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is signed in" do
      before { sign_in user }

      it "successfully shows conversations page" do
        match

        get conversations_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(other_user.email)
      end
    end
  end

  describe "GET /conversations/:id" do
    context "when user is not signed in" do
      it "redirects to sign in" do
        get conversation_path(match.conversation)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is signed in" do
      before { sign_in user }

      it "shows not found error when accessing unauthorized conversation" do
        get conversation_path(other_match.conversation)
        expect(response).to have_http_status(:not_found)
      end

      before do
        user_message
        other_user_message
      end

      it "successfully shows messages" do
        get conversation_path(match.conversation)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Hello")
        expect(response.body).to include("Reply")
      end

      it "shows messages by created order" do
        get conversation_path(match.conversation)
        expect(response.body.index(user_message.body)).to be < response.body.index(other_user_message.body)
      end
    end
  end
end
