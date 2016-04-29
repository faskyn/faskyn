require "rails_helper"
require "posts/post_comments_controller"

describe Posts::PostCommentsController do

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

      context "with valid attributes" do
        subject(:create_action) { xhr :post, :create, post_id: post_instance.id, post_comment: attributes_for(:post_comment, post_id: post_instance.id, user: @user) }

        it "saves the new task in the db" do
          expect{ create_action }.to change{ PostComment.count }.by(1)
        end

        it "assigns instance variables" do
          create_action
          expect(assigns(:post)).to eq(post_instance)
          #expect(assigns(:post_comment)).to be_a_new(PostComment)
          #expect(assigns(:post_comment.user)).to eq(@user)
          expect(assigns(:post_comment_reply)).to be_a_new(PostCommentReply)
        end

        it "assigns all the instance variables"

        it "responds with success" do
          create_action
          expect(response).to have_http_status(200)
        end
      end

      context "with invalid attributes" do
        subject(:create_action) { xhr :post, :create, post_id: post_instance.id, post_comment: attributes_for(:post_comment, post_id: post_instance.id, user: @user, body: "") }

        it "doesn't save the new product in the db" do
          expect{ create_action }.to_not change{ PostComment.count }
        end
      end
    end

    describe "PATCH update" do
      let!(:profile) { create(:profile, user: @user) }
      let!(:post) { create(:post, user: @user) }
      let!(:post_comment) { create(:post_comment, user: @user, post: post, body: "original body") }
      
      context "with valid attributes" do

        it "assigns the post and the new comment and reply" do
          patch :update, post_id: post.id, id: post_comment.id, post_comment: attributes_for(:post_comment), format: :json
          expect(assigns(:post_comment)).to eq(post_comment)
        end

        it "changes the attributes" do
          patch :update, post_id: post.id, id: post_comment.id, post_comment: attributes_for(:post_comment, body: "new body"), format: :json
          post_comment.reload
          expect(post_comment.body).to eq("new body")
        end

        it "responds with success" do
          patch :update, post_id: post.id, id: post_comment.id, post_comment: attributes_for(:post_comment), format: :json
          expect(response).to have_http_status(204)
        end
      end

      context "with invalid attributes" do

        it "doesn't change the attributes" do
          patch :update, post_id: post.id, id: post_comment.id, post_comment: attributes_for(:post_comment, body: ""), format: :json
          post_comment.reload
          expect(post_comment.body).to eq("original body")
        end
      end
    end

    describe "DELETE destroy" do
      let!(:post) { create(:post, user: @user) }
      let!(:post_comment) { create(:post_comment, user: @user, post: post) }

      it "destroys the product" do
        expect{ xhr :delete, :destroy, post_id: post.id, id: post_comment.id }.to change{ PostComment.count }.by(-1)
      end

      it "responds with success" do
        xhr :delete, :destroy, post_id: post.id, id: post_comment.id
        expect(response).to have_http_status(200)
      end
    end
  end
end