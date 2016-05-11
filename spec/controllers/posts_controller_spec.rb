require "rails_helper"
require "posts_controller"

describe PostsController do

  describe "when user is not logged in" do

    it "GET index redirectes to login" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "when user is logged in" do
    before(:each) do
      login_user
    end

    it "should have a current_user" do
      expect(subject.current_user).to_not eq(nil)
    end

    describe "GET index" do
      let!(:profile) { create(:profile, user: @user) }
      let!(:post) { create(:post, user: @user) }
      before(:each) do
        get :index
      end
        
      it "assigns posts" do
        expect(assigns(:posts)).to eq([post])
        expect(assigns(:post)).to be_a_new(Post)
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :index }
    end

    describe "GET show with picture"
    describe "GET show" do
      let!(:post) { create(:post, user: @user) }
      before(:each) do
        xhr :get, :show, id: post.id
      end

      it "assigns post" do
        expect(assigns(:post)).to eq(post)
      end
    end

    describe "GET edit" do
      let!(:post) { create(:post, user: @user) }
      before(:each) do
        xhr :get, :edit, id: post.id
      end

      it "assigns post" do
        expect(assigns(:post)).to eq(post)
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :edit }
    end

    describe "POST create" do
      let!(:profile) { create(:profile, user: @user) }

      context "with valid attributes" do
        subject(:create_action) { xhr :post, :create, post: attributes_for(:post, user: @user) }

        it "saves the new task in the db" do
          expect{ create_action }.to change{ Post.count }.by(1)
        end

        it "responds with success" do
          create_action
          expect(response).to have_http_status(200)
        end
      end

      context "with invalid attributes" do
        subject(:create_action) { xhr :post, :create, post: attributes_for(:post, user: @user, body: "") }

        it "doesn't save the new product in the db" do
          expect{ create_action }.to_not change{ Post.count }
        end
      end
    end

    describe "PATCH update" do
      let!(:profile) { create(:profile, user: @user) }
      let!(:post) { create(:post, user: @user, body: "original body") }
      
      context "with valid attributes" do

        it "assigns the post and the new comment and reply" do
          xhr :patch, :update, id: post.id, post: attributes_for(:post)
          expect(assigns(:post)).to eq(post)
        end

        it "changes the attributes" do
          xhr :patch, :update, id: post.id, post: attributes_for(:post, body: "new body")
          post.reload
          expect(post.body).to eq("new body")
        end

        it "responds with success" do
          xhr :patch, :update, id: post.id, post: attributes_for(:post)
          expect(response).to have_http_status(200)
        end
      end

      context "with invalid attributes" do

        it "doesn't change the attributes" do
          xhr :patch, :update, id: post.id, post: attributes_for(:post, body: "")
          post.reload
          expect(post.body).to eq("original body")
        end
      end
    end

    describe "DELETE destroy" do
      let!(:post) { create(:post, user: @user) }

      it "destroys the product" do
        expect{ xhr :delete, :destroy, id: post.id }.to change{ Post.count }.by(-1)
      end

      it "responds with success" do
        xhr :delete, :destroy, id: post.id
        expect(response).to have_http_status(200)
      end
    end
  end
end