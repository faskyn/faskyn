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

  def checking_decreasing
    notification = Notification.find(params[:notification])
    current_user.decreasing_other_notification_number(notification)
    redirect_to notification_redirection_path(notification)
  end

  private

    def notification_redirection_path(notification)
      klass = "NotificationRedirections::#{notification.notifiable_type}Redirection".constantize
      klass.new(notification: notification).send(notification.action)
    end

    # def notification_redirection_path(notification)
    #   type = notification.notifiable_type
    #   notifiable_id = notification.notifiable_id
    #   action = notification.action
    #   if action == "commented"
    #     route = case type
    #             when "Post"
    #               posts_path(anchor: "post_#{notifiable_id}")#{}"/posts#post_#{notifiable_id}"
    #             when "Product"
    #               product_path(notifiable_id, anchor: "comment-panel")#/products/#{notifiable_id}#comment-panel"
    #             when "ProductLead"
    #               product_lead = ProductLead.find(notifiable_id)
    #               product_id = product_lead.product_id
    #               product_product_lead_path(product_id, notifiable_id, anchor: "comment-panel")#{}"/products/#{product_id}/#{notifiable_type}/#{notifiable_id}#comment-panel"
    #             when "ProductCustomer"
    #               product_customer = ProductCustomer.find(notifiable_id)
    #               product_id = product_customer.product_id
    #               product_product_customer_path(product_id, notifiable_id, anchor: "comment-panel") #/products/#{product_id}/#{notifiable_type}/#{notifiable_id}#comment-panel"
    #             end
    #   elsif action == "invited"
    #     if type == "Product"
    #       product_path(notifiable_id, anchor: "product-invitation-well")
    #     elsif type == "ProductCustomer"
    #       product_customer = ProductCustomer.find(notifiable_id)
    #       product_id = product_customer.product_id
    #       product_product_customer_path(product_id, notifiable_id)
    #     end
    #   elsif action == "accepted"
    #     if type == "Product" #team member invitation
    #       product_product_owner_panels_path(notifiable_id)
    #     elsif type == "ProductCustomer" #referencer invitation
    #       product_customer = ProductCustomer.find(notifiable_id)
    #       product_id = product_customer.product_id
    #       product_product_owner_panels_path(product_id)
    #     end
    #   elsif action == "wrote"
    #     product_customer = ProductCustomer.find(notifiable_id)
    #     product_id = product_customer.product_id
    #     product_product_customer_path(product_id, notifiable_id)
    #   end
    # end

    def set_and_authorize_user_notifications
      @user = User.find(params[:user_id])
      authorize @user, :index_notifications?
    end
end
