require 'rails_helper'

describe TaskPolicy do
  subject { TaskPolicy }

  let(:executor) { build_stubbed(:user) }
  let(:assigner) { build_stubbed(:user) }
  let(:other_user) { build_stubbed(:user) }
  let(:task) { build_stubbed(:task, executor: executor, assigner: assigner) }

  #collections are tested in UserPolicy

  permissions :create? do

    it "allows acces for anybody" do
      expect(subject).to permit(executor)
      expect(subject).to permit(assigner)
      expect(subject).to permit(other_user)
    end
  end

  permissions :edit?, :update?, :complete?, :uncomplete?, :destroy? do

    it "allows acces for executor and assigner" do
      expect(subject).to permit(executor, task)
      expect(subject).to permit(assigner, task)
      expect(subject).to_not permit(other_user, task)
    end
  end
end