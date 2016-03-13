class Posts::PostCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @post_comment = @post.post_comments.build(post_comment_params)
    authorize @post_comment
    @post_comment.user = current_user
    @post_comment.save!
    if @post_comment.save
      (@post.users.uniq - [current_user, @post.user] + post_owner_check(@post, @post_comment)).each do |post_commenter|
        Notification.create(recipient_id: post_commenter.id, sender_id: current_user.id, notifiable: @post_comment.post, action: "commented")
      end
      respond_to do |format|
        format.html { redirect_to posts_path, notice: "Comment saved!" }
        format.js
      end
    end
  end

  def update
    @post_comment = PostComment.find(params[:id])
      respond_to do |format|
      if @post_comment.update_attributes(post_comment_params)
        format.json { respond_with_bip(@post_comment) }
      else
        format.json { respond_with_bip(@post_comment) }
      end
    end
  end

  def destroy
    @post_comment = PostComment.find(params[:id])
    if @post_comment.destroy
      respond_to do |format|
        format.html { redirect_to posts_path, notice: "Comment got deleted!"}
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to posts_path, notice: "Comment couldn't be deleted!"}
        format.js
      end
    end
  end

  private

    def post_owner_check(post, post_comment)
      post_comment.user == post.user ? [] : [post.user]
    end

    def post_comment_params
      params.require(:post_comment).permit(:body, :user)
    end
end