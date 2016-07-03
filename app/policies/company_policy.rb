class CompanyPolicy < ApplicationPolicy
  def show?
    user.present? && user.profile.present?
  end

  def edit?
    user.present? && user == company.product.owner
  end

  def update?
    user.present? && user == company.product.owner
  end

  private

    def company
      record
    end
end