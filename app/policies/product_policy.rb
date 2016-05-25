class ProductPolicy < ApplicationPolicy
  def index?
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
    user.present? && user == product.owner
  end

  def update?
    user.present? && user == product.owner
  end

  def destroy?
    user.present? && user == product.owner
  end

  def index_product_users?
    user.present? && user == product.owner
  end

  def destroy_product_users?
    user.present? && user == product.owner
  end

  def new_product_invitations?
    user.present? && user == product.owner
  end

  def create_product_invitations?
    user.present? && user == product.owner
  end

  private

    def product
      record
    end
end