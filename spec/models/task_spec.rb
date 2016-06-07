require 'rails_helper'

RSpec.describe Task, type: :model do

  describe "model validations" do

    it "has a valid factory" do
      expect(build_stubbed(:task)).to be_valid
    end

    it "is invalid without executor" do
      expect(build_stubbed(:task, executor_id: nil)).not_to be_valid
    end

    it "is invalid without assigner" do
      expect(build_stubbed(:task, assigner_id: nil)).not_to be_valid
    end

    it "is invalid without content" do
      expect(build_stubbed(:task, content: nil)).not_to be_valid
    end

    it "is invalid without deadline" do
      expect(build_stubbed(:task, deadline: nil)).not_to be_valid
    end

    it "is invalid with deadline in the past" do
      expect(build_stubbed(:task, deadline: Faker::Time.between(DateTime.now - 1, DateTime.now - 2))).not_to be_valid
    end

    it "is invalid with a completed_at in the future" do
      expect(build_stubbed(:task, completed_at: Faker::Time.between(DateTime.now + 1, DateTime.now + 2))).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:assigner) }
    it { is_expected.to validate_presence_of(:executor).with_message(/must be valid/) }
    it { is_expected.to validate_presence_of(:content).with_message(/can't be blank/) }
    it { is_expected.to validate_length_of(:content).is_at_most(140).with_message(/can't be longer than 140 characters/) }
    it { is_expected.to validate_presence_of(:deadline).with_message(/can't be blank/) }

    it { is_expected.to belong_to(:assigner) }
    it { is_expected.to belong_to(:executor) }
    it { is_expected.to have_many(:notifications).dependent(:destroy) }
  end

  describe "scopes" do
    let(:executor) { create(:user) }
    let(:assigner) { create(:user) }
    let(:uncompleted_task) { create(:task, executor: executor, assigner: assigner) }
    let(:completed_task) { create(:task, executor: executor, assigner: assigner, completed_at: DateTime.now - 2) }
    let(:other_task) { create(:task) }


    it "completed" do
      expect(Task.completed).to eq([completed_task])
      expect(Task.completed).not_to include(uncompleted_task)
    end

    it "uncompleted" do
      expect(Task.uncompleted).to eq([uncompleted_task, other_task])
      expect(Task.uncompleted).not_to include(completed_task)
    end

    it "alltasks" do
      expect(Task.alltasks(uncompleted_task.executor)).to eq([uncompleted_task, completed_task])
      expect(Task.alltasks(uncompleted_task.executor)).not_to include(other_task)
    end

    it "between" do
      eid = uncompleted_task.executor_id
      aid = uncompleted_task.assigner_id
      expect(Task.between(eid, aid)).to eq([uncompleted_task, completed_task])
      expect(Task.between(eid, aid)).not_to include(other_task)
    end
  end

  describe "instance methods" do
    let(:profile) { build(:profile) }
    let(:user) {build(:user) }
    let(:task) { build(:task) }
    let(:profile_setter) { create(:profile) }
    let!(:user_setter) { create(:user, profile: profile_setter) }
    let(:task_setter) { create(:task) }
  
    it "deadline_string getter" do
      task.deadline = "Wed, 27 Apr 2016 22:00:00 UTC +00:00"
      expect(task.deadline_string).to eq("2016-04-27T22:00:00+00:00")
    end

    it "deadline_string setter" do
      dl_string = "Wed, 27 Apr 2016 22:00:00 UTC +00:00"
      expect(task.deadline_string=dl_string).to eq("Wed, 27 Apr 2016 22:00:00 UTC +00:00")
    end

    it "task_name_company getter" do
      task.executor.profile = profile
      expect(task.task_name_company).to eq("John Doe Faskyn")
    end

    it "task_name_company setter" do
      task_setter.task_name_company = "John Doe Faskyn"
      expect(task_setter.executor).to eq(user_setter)
    end

    it "completed?" do
      task_completed = create(:task, completed_at: DateTime.now - 2)
      expect(task.completed?).to eq(nil)
      expect(task_completed.completed?).to_not eq(nil)
    end
  end
end