require "posts/post_comment_replies_controller"
require "rails_helper"

describe Posts::PostCommentRepliesController do

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
      let!(:profile) { create(:profile, user: @user) }
      let!(:post_instance) { create(:post, user: @user) }
      let!(:post_comment) { create(:post_comment, post: post_instance, user: @user) }

      context "with valid attributes" do
        subject(:create_action) { xhr :post, :create, post_comment_id: post_comment.id, post_comment_reply: attributes_for(:post_comment_reply, post_comment: post_comment, user: @user) }

        it "saves the new task in the db" do
          expect{ create_action }.to change{ PostCommentReply.count }.by(1)
        end
      end

      context "with invalid attributes" do
        subject(:create_action) { xhr :post, :create, post_comment_id: post_comment.id, post_comment_reply: attributes_for(:post_comment_reply, post_comment: post_comment, user: @user, body: "") }

        it "doesn't save the new product in the db" do
          expect{ create_action }.to_not change{ PostCommentReply.count }
        end
      end
    end

    describe "PATCH update" do
      let!(:profile) { create(:profile, user: @user) }
      let!(:post) { create(:post, user: @user) }
      let!(:post_comment) { create(:post_comment, user: @user, post: post) }
      let!(:post_comment_reply) { create(:post_comment_reply, user: @user, post_comment: post_comment, body: "original body") }
      
      context "with valid attributes" do

        it "assigns the post and the new comment and reply" do
          patch :update, post_comment_id: post_comment.id, id: post_comment_reply.id, post_comment_reply: attributes_for(:post_comment_reply), format: :json
          expect(assigns(:post_comment_reply)).to eq(post_comment_reply)
        end

        it "changes the attributes" do
          patch :update, post_comment_id: post_comment.id, id: post_comment_reply.id, post_comment_reply: attributes_for(:post_comment_reply, body: "new body"), format: :json
          post_comment_reply.reload
          expect(post_comment_reply.body).to eq("new body")
        end

        it "responds with success" do
          patch :update, post_comment_id: post_comment.id, id: post_comment_reply.id, post_comment_reply: attributes_for(:post_comment_reply), format: :json
          expect(response).to have_http_status(204)
        end
      end

      context "with invalid attributes" do

        it "doesn't change the attributes" do
          patch :update, post_comment_id: post_comment.id, id: post_comment_reply.id, post_comment_reply: attributes_for(:post_comment_reply, body: ""), format: :json
          post_comment_reply.reload
          expect(post_comment_reply.body).to eq("original body")
        end
      end
    end

    describe "DELETE destroy" do
      let!(:post_comment) { create(:post_comment, user: @user) }
      let!(:post_comment_reply) { create(:post_comment_reply, user: @user, post_comment: post_comment) }

      it "destroys the product" do
        expect{ xhr :delete, :destroy, post_comment_id: post_comment.id, id: post_comment_reply.id }.to change{ PostCommentReply.count }.by(-1)
      end

      it "responds with success" do
        xhr :delete, :destroy, post_comment_id: post_comment.id, id: post_comment_reply.id
        expect(response).to have_http_status(200)
      end
    end
  end
end