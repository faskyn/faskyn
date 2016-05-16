require "rails_helper"

describe Posts::CommentsController do

  describe "when user is logged in" do
    
    before(:each) do
      login_user
    end

    it "should have a current_user" do
      expect(subject.current_user).to_not eq(nil)
    end

    describe "POST create" do
      let!(:user) { create(:user) }
      let!(:profile) { create(:profile, user: @user) }
      let!(:commentable) { create(:post, user: @user) }
      let!(:other_Comment) { create(:comment, commentable: commentable, user: user) }

      context "with valid attributes" do
        subject(:create_action) { xhr :post, :create, post_id: commentable, comment: attributes_for(:comment, commentable: commentable, user: @user) }

        it "saves the new task in the db" do
          expect{ create_action }.to change{ Comment.count }.by(1)
        end

        it "sends notification" do
          expect{ create_action }.to change{ Notification.count }.by(1)
        end

        it "assigns instance variables" do
          create_action
          expect(assigns(:commentable)).to eq(commentable)
          expect(assigns(:current_user)).to eq(@user)
        end

        it "responds with success" do
          create_action
          expect(response).to have_http_status(200)
        end
      end

      context "with invalid attributes" do
        subject(:create_action) { xhr :post, :create, post_id: commentable, comment: attributes_for(:comment, commentable: commentable, user: @user, body: "") }

        it "doesn't save the new product in the db" do
          expect{ create_action }.to_not change{ Comment.count }
        end

        it "doesn't send notification" do
          expect{ create_action }.to_not change{ Notification.count }
        end
      end
    end
  end
end