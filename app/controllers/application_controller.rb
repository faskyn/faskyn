class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  protect_from_forgery with: :exception
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper_method :if_no_profile_exists
  helper_method :google7df1f819c8dc9008
  helper_method :notification_redirection_path

  before_action :set_sidebar_users
  before_action :set_sidebar_products

  def google7df1f819c8dc9008
  end

  def set_sidebar_users
    @profiles_sidebar = Profile.order(created_at: :desc).includes(:user).limit(3) if user_signed_in?
  end

  def set_sidebar_products
    @products_sidebar = Product.order(updated_at: :desc).limit(3) if user_signed_in?
  end

  def notification_redirection_path(notifiable_type, notifiable_id)
    route = case notifiable_type
            when "Post"
              "/posts#post_#{notifiable_id}"
            when "Product"
              "/products/#{notifiable_id}#comment-panel"
            end
  end

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash[:danger] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to(request.referrer || root_path)
  end
end
