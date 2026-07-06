require "rails_helper"

RSpec.describe "Conversations", type: :request do
  let(:user) { create (:user) }
  let(:other_user) { create(:user) }
  let(:match) { create(:match, user_one: user, user_two: other_user) }
  let(:conversation) { match.conversation }

  describe "POST /conversations/:conversation_id/messages" do
    context "when user is not signed in" do
      it "redirects user to login" do
        post conversation_messages_path(conversation)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is signed in" do
      before { sign_in user }

      it "creates a message successfully" do
        expect {
          post conversation_messages_path(conversation), params: {
            message: {
              body: "Hello"
            }
          }
        }.to change(Message, :count).by(1)

        expect(Message.last.body).to eq("Hello")
        expect(Message.last.sender).to eq(user)
        expect(Message.last.conversation).to eq(conversation)
      end

      it "redirects to the conversation page after success" do
        post conversation_messages_path(conversation), params: {
          message: {
            body: "Hello"
          }
        }
        expect(response).to redirect_to(conversation_path(conversation))
      end

      it "does not create a message and renders show when message is invalid" do
        expect {
          post conversation_messages_path(conversation), params: {
            message: {
              body: ""
            }
          }
        }.not_to change(Message, :count)

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("Send")
      end
    end
  end
end
