class ProductCustomerPolicy < ApplicationPolicy
  def show?
    user.present? && user.profile.present?
  end

  def create_reviews?
    user.present? && product_customer.user?(user)
  end

  def destroy_review?
    user.present? && user == product_customer.owner
  end

  private

    def product_customer
      record
    end
end