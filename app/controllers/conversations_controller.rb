class ConversationsController < ApplicationController
  before_action :authenticate_user!

  private
    def conversation_params
      params.permit(:sender_id, :recipient_id)
    end
end
