class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_and_authorize_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.order(created_at: :desc).includes(:user).paginate(page: params[:page], per_page: 4)
    authorize @posts
    @post = Post.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    respond_to :js
  end

  def new
    @post = Post.new
    authorize @post
  end

  def create
    @post = current_user.posts.new(post_params)
    authorize @post
    if @post.save
      #@post.send_post_creation_email_notification(@post.user)
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
    respond_to :js
  end

  def update
    if @post.update_attributes(post_params)
      respond_to do |format|
        format.html { redirect_to @post, notice: "Post was successfully updated!"}
        format.js
      end
    else
      respond_to do |format|
        format.html { render action: :edit, alert: "Post couldn't be updated!"}
        format.js
      end
    end
  end

  def destroy
    if @post.destroy
      respond_to do |format|
        format.html { redirect_to post_path, notice: "Post got deleted!"}
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to post_path, notice: "Post couldn't be deleted!"}
        format.js
      end
    end
  end

  private

    def post_params
      params.require(:post).permit(:body, :user_id, :post_image, :post_image_cache)
    end

    def set_and_authorize_post
      @post = Post.find(params[:id])
      authorize @post
    end
end
