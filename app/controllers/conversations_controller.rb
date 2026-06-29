class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [ :show ]

  def index
    @conversations = Conversation.joins(:match).
                    where(matches: { user_one_id: current_user.id }).
                    or(
                      Conversation.joins(:match).
                      where(matches: { user_two_id: current_user.id })
                    ).includes(match: [ :user_one, :user_two ]).
                    order(updated_at: :desc)
  end

  def show
    @messages     = @conversation.messages.includes(:sender).order(:created_at)
    @message      = Message.new
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
