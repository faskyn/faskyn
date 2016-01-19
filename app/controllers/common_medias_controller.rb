class CommonMediasController < ApplicationController
  
  require "will_paginate/array"

  before_action :authenticate_user!, only: :index
  before_action :set_users_and_conversation

  def common_medias
    @messages = @conversation.messages.includes(:user).order(created_at: :desc).limit(50).reverse
    @message = Message.new
    respond_to :html
  end

  def get_files #loading files data with js on common_medias page
    @common_files = @conversation.messages.with_file.order(created_at: :desc).paginate(page: params[:files], per_page: 14)
    respond_to :js
  end

  def get_links #loading links data with js on common_medias page
    @message_links_pre = @conversation.messages.with_link.order(created_at: :desc).paginate(page: params[:links], per_page: 14)
    @message_links = @message_links_pre.map { |f| { link: f.link, created_at: f.created_at, user_id: f.user_id} }.flatten
    @common_links = formatting_links(@message_links)
    respond_to :js
  end

  def get_calendars #loading calendars data with js on common_medias page
    respond_to :js
  end

  private

    def set_users_and_conversation
      @param_id = request.parameters['user_id']
      @user = User.find(@param_id)
      if Conversation.between(current_user.id, @user.id).present?
        @conversation ||= Conversation.between(current_user.id, @user.id).first
      else
        begin
          redirect_to :back, notice: "You have to create a common task first with #{@user.profile.full_name}!"
        rescue ActionController::RedirectBackError
          redirect_to root_path(current_user)
        end
      end
    end

    #formatting serialized links to have separated lines for each of them
    def formatting_links(message_links)
      formatted_message_links = []
      message_links.each do |message|
        puts message[:link]
        message[:link].each do |link|
          array = {}
          array['link'] = link[0]
          array['created_at'] = message[:created_at]
          array['user_id'] = message[:user_id]
          puts array
          formatted_message_links << array
        end
      end
      formatted_message_links
    end
end