class Posts::PostCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @post_comment = @post.post_comments.build(post_comment_params)
    authorize @post_comment
    @post_comment.user = current_user
    @post_comment.save!
    respond_to do |format|
      format.html { redirect_to posts_path, notice: "Comment saved!" }
      format.js
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

  private

    def post_comment_params
      params.require(:post_comment).permit(:body, :user_id, :user_profile)
    end
end