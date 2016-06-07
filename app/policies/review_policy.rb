class ReviewPolicy < ApplicationPolicy

  def edit?
    user.present? && user == review.user
  end
 
  def update?
    user.present? && user == review.user
  end

  private

    def review
      record
    end
end