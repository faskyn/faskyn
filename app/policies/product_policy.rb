class ProductPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def own_products?
    user.present?
  end

  def show?
    user.present? && user.profile.present?
  end

  def new?
    user.present? && user.profile.present?
  end

  def create?
    user.present? && user.profile.present?
  end

  def edit?
    user.present? && user == product.user
  end

  def update?
    user.present? && user == product.user
  end

  def delete?
    user.present? && user == product.user
  end

  def destroy?
    user.present? && user == product.user
  end

  private

    def product
      record
    end
end