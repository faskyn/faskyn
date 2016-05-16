require "comments/comment_replies_controller"
require "rails_helper"

describe Comments::CommentRepliesController do

  describe "when user is not logged in" do
  end

  describe "when user is logged in" do
    before(:each) do
      login_user
    end

    it "should have a current_user" do
      expect(subject.current_user).to_not eq(nil)
    end

    describe "POST create" do
      let(:user) { create(:user) }
      let!(:profile) { create(:profile, user: @user) }
      let(:commentable) { create(:post, user: @user) }
      let(:comment) { create(:comment, commentable: commentable, user: @user) }
      let!(:other_reply) { create(:comment_reply, comment: comment, user: user) }

      context "with valid attributes" do
        subject(:create_action) { xhr :post, :create, comment_id: comment.id, comment_reply: attributes_for(:comment_reply, comment: comment, user: @user) }

        it "saves the new task in the db" do
          expect{ create_action }.to change{ CommentReply.count }.by(1)
        end

        it "sends notification" do
          expect{ create_action }.to change{ Notification.count }.by(1)
        end
      end

      context "with invalid attributes" do
        subject(:create_action) { xhr :post, :create, comment_id: comment.id, comment_reply: attributes_for(:comment_reply, comment: comment, user: @user, body: "") }

        it "doesn't save the new product in the db" do
          expect{ create_action }.to_not change{ CommentReply.count }
        end

        it "doesn't send notification" do
          expect { create_action }.to_not change{ Notification.count }
        end
      end
    end

    describe "PATCH update" do
      let!(:profile) { create(:profile, user: @user) }
      let(:commentable) { create(:post, user: @user) }
      let(:comment) { create(:comment, commentable: commentable, user: @user) }
      let(:comment_reply) { create(:comment_reply, comment: comment, user: @user, body: "original body") }
      
      context "with valid attributes" do

        it "assigns the commentable and the new comment and reply" do
          patch :update, comment_id: comment.id, id: comment_reply.id, comment_reply: attributes_for(:comment_reply), format: :json
          expect(assigns(:comment_reply)).to eq(comment_reply)
        end

        it "changes the attributes" do
          patch :update, comment_id: comment.id, id: comment_reply.id, comment_reply: attributes_for(:comment_reply, body: "new body"), format: :json
          comment_reply.reload
          expect(comment_reply.body).to eq("new body")
        end

        it "responds with success" do
          patch :update, comment_id: comment.id, id: comment_reply.id, comment_reply: attributes_for(:comment_reply), format: :json
          expect(response).to have_http_status(204)
        end
      end

      context "with invalid attributes" do

        it "doesn't change the attributes" do
          patch :update, comment_id: comment.id, id: comment_reply.id, comment_reply: attributes_for(:comment_reply, body: ""), format: :json
          comment_reply.reload
          expect(comment_reply.body).to eq("original body")
        end
      end
    end

    describe "DELETE destroy" do
      let(:commentable) { create(:post, user: @user) }
      let(:comment) { create(:comment, commentable: commentable, user: @user) }
      let!(:comment_reply) { create(:comment_reply, comment: comment, user: @user) }

      it "destroys the product" do
        expect{ xhr :delete, :destroy, comment_id: comment.id, id: comment_reply.id }.to change{ CommentReply.count }.by(-1)
      end

      it "responds with success" do
        xhr :delete, :destroy, comment_id: comment.id, id: comment_reply.id
        expect(response).to have_http_status(200)
      end
    end
  end
end