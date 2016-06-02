require "rails_helper"

RSpec.describe User, type: :model do

  describe "model validations" do

    it "has a valid factory" do
      expect(build_stubbed(:user)).to be_valid
    end
  
    it "is invalid without email" do
      expect(build_stubbed(:user, email: nil)).not_to be_valid
    end 

    it "is invalid without password" do
      expect(build_stubbed(:user, password: nil)).not_to be_valid
    end

    it "is invalid without chat_notification_number" do
      expect(build_stubbed(:user, new_chat_notification: nil)).not_to be_valid
    end

    it "is invalid without other_notification_number" do
      expect(build_stubbed(:user, new_other_notification: nil)).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_numericality_of(:new_chat_notification).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:new_other_notification).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to have_many(:conversations) }
    it { is_expected.to have_many(:messages) }
    it { is_expected.to have_one(:profile) }
    it { is_expected.to have_many(:socials) }
    it { is_expected.to have_many(:assigned_tasks) }
    it { is_expected.to have_many(:executed_tasks) }
    it { is_expected.to have_many(:products) }
    it { is_expected.to have_many(:notifications) }
    it { is_expected.to have_many(:posts) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:comment_replies) }
    it { is_expected.to have_many(:product_customer_users) }
    it { is_expected.to have_many(:referencable_product_customers).through(:product_customer_users) }
    it { is_expected.to have_many(:product_users) }
    it { is_expected.to have_many(:products).through(:product_users) }
    it { is_expected.to have_many(:own_products).through(:product_users) }
    it { is_expected.to have_many(:product_invitations) }

    it { is_expected.to delegate_method(:first_name).to(:profile) }
    it { is_expected.to delegate_method(:last_name).to(:profile) }
    it { is_expected.to delegate_method(:full_name).to(:profile) }
    it { is_expected.to delegate_method(:company).to(:profile) }
    it { is_expected.to delegate_method(:job_title).to(:profile) }
    it { is_expected.to delegate_method(:location).to(:profile) }
    it { is_expected.to delegate_method(:phone_number).to(:profile) }
    it { is_expected.to delegate_method(:description).to(:profile) }
    it { is_expected.to delegate_method(:avatar).to(:profile) }
  end

  describe "instance methods" do
    describe "notification methods" do
      let(:sender) { create(:user) }
      let(:user) { create(:user) }
      let(:post) { create(:post) }
      let(:chat_notification) { create(:notification, notifiable_type: "Message", recipient: user, sender: sender, checked_at: nil) }
      let(:task_notification) { create(:notification, notifiable_type: "Task", recipient: user, sender: sender, checked_at: nil) }
      let(:post_notification) { create(:notification, notifiable_type: "Post", recipient: user, sender: sender, checked_at: nil, notifiable_id: post.id)}

      it "decreasing_chat_notification_number" do
        expect(user).to receive(:checking_and_decreasing_notification).with(chat_notification)
        user.decreasing_chat_notification_number(sender)
      end

      it "decreasing_task_notification_number" do
        expect(user).to receive(:checking_and_decreasing_notification).with(task_notification)
        user.decreasing_task_notification_number(sender)
      end

      it "decreasing_post_notification_number" do
        expect(user).to receive(:checking_and_decreasing_notification).with(post_notification)
        user.decreasing_comment_notification_number("Post", post.id)
      end

      it "checking_and_decreasing_notification with chat notification" do
        expect(chat_notification).to receive(:check_notification)
        expect(user).to receive(:decrease_new_chat_notifications)
        expect(user).to receive(:decreased_chat_number_pusher)
        user.checking_and_decreasing_notification(chat_notification)
      end

      it "checking_and_decreasing_notification with other notification" do
        expect(task_notification).to receive(:check_notification)
        expect(user).to receive(:decrease_new_other_notifications)
        expect(user).to receive(:decreased_other_number_pusher)
        user.checking_and_decreasing_notification(task_notification)
      end

      it "increase_new_chat_notifications" do
        expect{user.increase_new_chat_notifications}.to change{user.new_chat_notification}.by(1)
      end

      context "decrease_new_other_notifications" do
        it "doesn't decrease the number if 0" do
          user.new_chat_notification = 0
          expect{user.decrease_new_chat_notifications}.to change{user.new_chat_notification}.by(0)
        end

        it "decrease the number if greater than 0" do
          user.new_chat_notification = 1
          expect{user.decrease_new_chat_notifications}.to change{user.new_chat_notification}.by(-1)
        end
      end

      it "reset_new_chat_notifications" do
        user.new_chat_notification = 2
        number = user.new_chat_notification
        expect{user.reset_new_chat_notifications}.to change{user.new_chat_notification}.by(-number)
      end

      it "increase_new_other_notifications" do
        expect{user.increase_new_other_notifications}.to change{user.new_other_notification}.by(1)
      end

      context "decrease_new_other_notifications" do
        it "doesn't decrease the number if 0" do
          user.new_other_notification = 0
          expect{user.decrease_new_other_notifications}.to change{user.new_other_notification}.by(0)
        end

        it "decrease the number if greater than 0" do
          user.new_other_notification = 1
          expect{user.decrease_new_other_notifications}.to change{user.new_other_notification}.by(-1)
        end
      end

      it "reset_new_other_notifications" do
        user.new_other_notification = 2
        number = user.new_other_notification
        expect{user.reset_new_other_notifications}.to change{user.new_other_notification}.by(-number)
      end

      it "decreased_chat_number_pusher" do
        user.new_chat_notification = 3
        number = user.new_chat_notification
        expect(Pusher).to receive(:trigger_async).with(('private-' + user.id.to_s), 'new_chat_notification', {number: number} )
        user.decreased_chat_number_pusher
      end

      it "decreased_other_number_pusher" do
        user.new_other_notification = 4
        number = user.new_other_notification
        expect(Pusher).to receive(:trigger_async).with(('private-' + user.id.to_s), 'new_other_notification', {number: number} )
        user.decreased_other_number_pusher
      end
    end

    describe "product invitation methods" do
      let(:owner) { create(:user) }
      let(:no_member) { create(:user) }
      let(:product) { create(:product, :product_with_nested_attrs) }
      let!(:product_user) { create(:product_user, product: product, user: owner, role: "owner") }
      
      it "is invited or a team member?" do
       expect(owner.is_invited_or_member?(product)).to eq(true)
       expect(no_member.is_invited_or_member?(product)).to eq(false)
      end
    end
  end
end