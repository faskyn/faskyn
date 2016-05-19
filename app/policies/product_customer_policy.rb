class ProductCustomerPolicy < ApplicationPolicy
  def show?
    user.present? && user.profile.present?
  end

  private

    def product_customer
      record
    end
end