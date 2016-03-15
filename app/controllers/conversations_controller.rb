class ConversationsController < ApplicationController
  before_action :authenticate_user!
end
