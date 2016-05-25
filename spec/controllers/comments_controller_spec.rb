require "rails_helper"

describe CommentsController do

  describe "when user is logged in" do
    
    before(:each) do
      login_user
    end

    it "should have a current_user" do
      expect(subject.current_user).to_not eq(nil)
    end

    describe "PATCH update" do
      let!(:profile) { create(:profile, user: @user) }
      let!(:commentable) { create(:post, user: @user) }
      let!(:comment) { create(:comment, user: @user, commentable: commentable, body: "original body") }
      
      context "with valid attributes" do

        it "assigns the comment" do
          patch :update, id: comment.id, comment: attributes_for(:comment), format: :json
          expect(assigns(:comment)).to eq(comment)
        end

        it "changes the attributes" do
          patch :update, id: comment.id, comment: attributes_for(:comment, body: "new body"), format: :json
          comment.reload
          expect(comment.body).to eq("new body")
        end

        it "responds with success" do
          patch :update, id: comment.id, comment: attributes_for(:comment), format: :json
          expect(response).to have_http_status(204)
        end
      end

      context "with invalid attributes" do

        it "doesn't change the attributes" do
          patch :update, id: comment.id, comment: attributes_for(:comment, body: ""), format: :json
          comment.reload
          expect(comment.body).to eq("original body")
        end
      end
    end

    describe "DELETE destroy" do
      let!(:commentable) { create(:post, user: @user) }
      let!(:comment) { create(:comment, commentable: commentable, user: @user) }

      it "destroys the comment" do
        expect{ xhr :delete, :destroy, id: comment.id }.to change{ Comment.count }.by(-1)
      end

      it "responds with success" do
        xhr :delete, :destroy, id: comment.id
        expect(response).to have_http_status(200)
      end
    end
  end
end