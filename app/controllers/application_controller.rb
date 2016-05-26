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

  def notification_redirection_path(notifiable_type, notifiable_id, action)
    if action == "commented"
      if notifiable_type == "ProductCustomer"
        product_customer = ProductCustomer.find(notifiable_id)
        product_id = product_customer.product_id
      elsif notifiable_type == "ProductLead"
        product_lead = ProductLead.find(notifiable_id)
        product_id = product_lead.product_id
      end
      route = case notifiable_type
              when "Post"
                posts_path(anchor: "post_#{notifiable_id}")#{}"/posts#post_#{notifiable_id}"
              when "Product"
                product_path(notifiable_id, anchor: "comment-panel")#/products/#{notifiable_id}#comment-panel"
              when "ProductLead"
               product_product_lead_path(product_id, notifiable_id, anchor: "comment-panel")#{}"/products/#{product_id}/#{notifiable_type}/#{notifiable_id}#comment-panel"
              when "ProductCustomer"
               product_product_customer_path(product_id, notifiable_id, anchor: "comment-panel") #/products/#{product_id}/#{notifiable_type}/#{notifiable_id}#comment-panel"
              end
    elsif action == "invited"
      product_path(notifiable_id, anchor: "product-invitation-well")
    elsif action == "accepted"
      product_product_users_path(notifiable_id)
    end
  end

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash[:danger] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to(request.referrer || root_path)
  end
end
