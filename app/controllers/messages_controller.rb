class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  def create
    @message = @conversation.messages.build(message_params)
    @message.sender = current_user

    if @message.save
      redirect_to conversation_path(@conversation)
    else
      @messages = @conversation.messages.includes(:sender).order(:created_at)
      render "conversations/show", status: :unprocessable_content
    end
  end

  private

  def set_conversation
    @conversation = Conversation.joins(:match).
                    where(
                      "matches.user_one_id = :id OR matches.user_two_id = :id",
                      id: current_user.id
                    ).find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
