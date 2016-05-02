require 'rails_helper'

describe UserPolicy do
  subject { UserPolicy }

  let(:current_user) { build_stubbed(:user) }
  let(:other_user) { build_stubbed(:user) }

  permissions :index?, :show? do

    it "allows acces for anybody" do
      expect(subject).to permit(current_user)
    end
  end

  permissions :index_tasks?, :index_notifications?, :index_own_products? do

    it "allows access only to current user" do
      expect(subject).to permit(current_user, current_user)
      expect(subject).to_not permit(current_user, other_user)
    end
  end
end