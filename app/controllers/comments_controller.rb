class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_and_authorize_comment, only: [:update, :destroy]

  def create
    @comment = @commentable.comments.new(comment_params)
    authorize @comment
    @comment.user = current_user
    if @comment.save
      @comment.send_comment_creation_notification(@commentable)
      respond_to :js
    end
  end

  def update
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

    def set_and_authorize_comment
      @comment = Comment.find(params[:id])
      authorize @comment
    end
end