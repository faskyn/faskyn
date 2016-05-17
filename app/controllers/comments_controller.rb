class CommentsController < ApplicationController
    before_action :authenticate_user!

    def create
      # @post = Post.find(params[:post_id])
      # @post_comment = @post.post_comments.build(post_comment_params)
      # authorize @post_comment
      # @post_comment.user = current_user
      # #@post_comment.save!
      # if @post_comment.save
      #   @post.send_post_comment_creation_notification(@post_comment)
      #   respond_to :js
      # end
      @comment = @commentable.comments.new(comment_params)
      authorize @comment
      @comment.user = current_user
      if @comment.save
        @comment.send_comment_creation_notification(@commentable)
        respond_to :js
      end
    end

  def update
  #   @post_comment = PostComment.find(params[:id])
  #   authorize @post_comment
  #   respond_to do |format|
  #     if @post_comment.update_attributes(post_comment_params)
  #       format.json { respond_with_bip(@post_comment) }
  #     else
  #       format.json { respond_with_bip(@post_comment) }
  #     end
  #   end
    @comment = Comment.find(params[:id])
    authorize @comment
    if @comment.update_attributes(comment_params)
      respond_to do |format|
        format.json { respond_with_bip(@comment) }
      end
    else
      respond_to do |format|
        format.json { respond_with_bip(@comment) }
      end
    end
  end

  def destroy
  #   @post_comment = PostComment.find(params[:id])
  #   authorize @post_comment
  #   if @post_comment.destroy
  #     respond_to do |format|
  #       format.html { redirect_to posts_path, notice: "Comment got deleted!"}
  #       format.js
  #     end
  #   else
  #     respond_to do |format|
  #       format.html { redirect_to posts_path, notice: "Comment couldn't be deleted!"}
  #       format.js
  #     end
  #   end
    @comment = Comment.find(params[:id])
    authorize @comment
    if @comment.destroy
      respond_to :js
    else
      respond_to :js
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body)
    end

  #   def post_comment_params
  #     params.require(:post_comment).permit(:body, :user)
  #   end
end