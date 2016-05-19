class ProductLeadPolicy < ApplicationPolicy
  def show?
    user.present? && user.profile.present?
  end

  private

    def product_lead
      record
    end
end