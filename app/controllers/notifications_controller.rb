class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_and_authorize_user_notifications

  require 'will_paginate/array'

  def other_notifications
    @other_notifications = current_user.notifications.not_chat.order(created_at: :desc).includes(:sender_profile).paginate(page: params[:page], per_page: Notification.pagination_per_page)
    current_user.reset_new_other_notifications
    respond_to do |format|
      format.html
      format.js
    end
  end

  def chat_notifications
    @chat_notifications = current_user.notifications.chat.order(created_at: :desc).includes(:sender_profile).paginate(page: params[:page], per_page: Notification.pagination_per_page)
    current_user.reset_new_chat_notifications
    respond_to do |format|
      format.html
      format.js
    end
  end

  def chat_notifications_dropdown
    @chat_notifications = current_user.notifications.chat.unchecked.order(created_at: :desc).limit(10)
    respond_to :json
  end

  def other_notifications_dropdown
    @other_notifications = current_user.notifications.not_chat.unchecked.order(created_at: :desc).limit(10)
    respond_to :json
  end

  def dropdown_checking_decreasing
    current_user.decreasing_post_notification_number(params[:post_id])
    redirect_to posts_path(anchor: params[:anchor_param])
  end

  private

    def set_and_authorize_user_notifications
      @user = User.find(params[:user_id])
      authorize @user, :show_notifications?
    end
end
