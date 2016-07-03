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

  def index_product_owner_panels?
    user.present? && user == product.owner
  end

  def destroy_product_users?
    user.present? && user == product.owner
  end

  def destroy_product_customer_users?
    user.present? && user == product.owner
  end

  def new_group_invitations?
    user.present? && user == product.owner
  end

  def create_group_invitations?
    user.present? && user == product.owner
  end

  def new_company?
    user.present? && user == product.owner && product.company.blank?
  end

  def create_company?
    user.present? && user == product.owner && product.company.blank?
  end

  def destroy_company?
    user.present? && user == product.owner
  end

  private

    def product
      record
    end
end