class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [ :show ]

  def index
    @conversations =
    Conversation
      .joins(:match)
      .where(
        "matches.user_one_id = :id OR matches.user_two_id = :id",
        id: current_user.id
      )
      .includes(match: [ user_one: :profile, user_two: :profile ])
      .order(updated_at: :desc)

      @unread_counts =
        Message
          .where(conversation_id: @conversations.select(:id))
          .where.not(sender_id: current_user.id)
          .where(read_at: nil)
          .group(:conversation_id)
          .count
  end

  def show
    @conversation.messages
                .where.not(sender_id: current_user.id)
                .where(read_at: nil)
                .update_all(read_at: Time.current)

    @messages = @conversation.messages
                            .includes(sender: :profile)
                            .order(:created_at)

    @message = Message.new
  end

  private

  def set_conversation
    @conversation = Conversation.joins(:match).
                    where(
                      "matches.user_one_id = :id OR matches.user_two_id = :id",
                      id: current_user.id
                    ).
                    find(params[:id])
  end
end
