class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_and_authorize_user_notifications

  require 'will_paginate/array'

  def other_notifications
    @other_notifications = current_user.notifications.where.not('notifications.notification_type = ?', 'chat').order(created_at: :desc).paginate(page: params[:page], per_page: Notification.pagination_per_page)
    current_user.reset_new_other_notifications
    respond_to do |format|
      format.html
      format.js
    end
  end

  def chat_notifications
    @chat_notifications = current_user.notifications.where('notifications.notification_type = ?', 'chat').order(created_at: :desc).paginate(page: params[:page], per_page: Notification.pagination_per_page)
    current_user.reset_new_chat_notifications
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

    def set_and_authorize_user_notifications
      @user = User.find(params[:user_id])
      authorize @user, :show_notifications?
    end

    def notification_params
      params.require(:notification).permit(:recipient_id, :sender_id, :notification_type, :checked_at)
    end
end
