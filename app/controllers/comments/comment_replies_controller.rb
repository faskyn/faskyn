class Comments::CommentRepliesController < ApplicationController
  before_action :authenticate_user!

  def create
    # @post_comment = PostComment.find(params[:post_comment_id])
    # @post = @post_comment.post
    # @post_comment_reply = @post_comment.post_comment_replies.build(post_comment_reply_params)
    # authorize @post_comment_reply
    # @post_comment_reply.user = current_user
    # #@post_comment_reply.save!
    # if @post_comment_reply.save
    #   @post_comment.send_post_comment_reply_creation_notification(@post_comment_reply)
    #   respond_to :js
    # end
    @comment = Comment.find(params[:comment_id])
    @commentable = @comment.commentable
    @comment_reply = @comment.comment_replies.new(comment_reply_params)
    authorize @comment_reply
    @comment_reply.user = current_user
    if @comment_reply.save
      @comment_reply.send_comment_reply_creation_notification(@comment) unless @comment.commentable_type == "Product"
      respond_to :js
    end
  end

  def update
    # @post_comment_reply = PostCommentReply.find(params[:id])
    # authorize @post_comment_reply
    # respond_to do |format|
    #   if @post_comment_reply.update_attributes(post_comment_reply_params)
    #     format.json { respond_with_bip(@post_comment_reply) }
    #   else
    #     format.json { respond_with_bip(@post_comment_reply) }
    #   end
    # end
    @comment_reply = CommentReply.find(params[:id])
    authorize @comment_reply
    respond_to do |format|
      if @comment_reply.update_attributes(comment_reply_params)
        format.json { respond_with_bip(@comment_reply) }
      else
        format.json { respond_with_bip(@comment_reply) }
      end
    end
  end

  def destroy
    @comment_reply = CommentReply.find(params[:id])
    @comment = @comment_reply.comment
    authorize @comment_reply
    if @comment_reply.destroy
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  private

    def comment_reply_params
      params.require(:comment_reply).permit(:body, :user)
    end
end