class Posts::PostCommentRepliesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post_comment = PostComment.find(params[:post_comment_id])
    @post = @post_comment.post
    @post_comment_reply = @post_comment.post_comment_replies.build(post_comment_reply_params)
    authorize @post_comment_reply
    @post_comment_reply.user = current_user
    @post_comment_reply.save!
    if @post_comment_reply.save
      @post_comment.send_post_comment_reply_creation_notification(@post_comment_reply)
      respond_to do |format|
        format.html { redirect_to posts_path, notice: "Comment reply saved!" }
        format.js
      end
    else
      respond_to do |format|
        format.html
      end
    end
  end

  def update
    @post_comment_reply = PostCommentReply.find(params[:id])
    authorize @post_comment_reply
    respond_to do |format|
      if @post_comment_reply.update_attributes(post_comment_reply_params)
        format.json { respond_with_bip(@post_comment_reply) }
      else
        format.json { respond_with_bip(@post_comment_reply) }
      end
    end
  end

  def destroy
    @post_comment_reply = PostCommentReply.find(params[:id])
    @post_comment = @post_comment_reply.post_comment
    authorize @post_comment_reply
    if @post_comment_reply.destroy
      respond_to do |format|
        format.html { redirect_to posts_path, notice: "Reply got deleted!"}
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to posts_path, notice: "Reply couldn't be deleted!"}
        format.js
      end
    end
  end

  private

    def post_comment_reply_params
      params.require(:post_comment_reply).permit(:body, :user)
    end
end