class CommonMediasController < ApplicationController
  before_action :authenticate_user!, only: :index

  def common_medias
    @param_id = request.parameters['user_id']
    @user = User.find(@param_id)
    @conversation ||= Conversation.between(current_user.id, @user.id).first
    @messages = @conversation.messages.includes(:user).order(created_at: :desc).limit(50).reverse
    @message = Message.new
    @message_files = @conversation.messages.with_file.order(created_at: :desc).paginate(page: params[:page], per_page: 12)
    #messages can have multiple links, but with the following link can be displayed separately with files
    @message_links_pre = @conversation.messages.with_link.order(created_at: :desc).paginate(page: params[:page], per_page: 12)
    @message_links = @message_links_pre.map { |f| { link: f.link, created_at: f.created_at, user_id: f.user_id} }.flatten
    @message_links_formatted = formatting_links(@message_links) 
  end

  private

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