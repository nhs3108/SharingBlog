class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :update, :destroy]
  def new
  end

  def create
    @comment = Comment.new(comment_params)
    @entry = @comment.entry
    if @comment.save
      respond_to do |format|
        format.html do 
          flash[:success] = "Comment was posted successfully!"
          redirect_to root_url
        end
        format.js do
        end
      end
    else
      flash[:danger] = "Cannot send comment #{@comment.errors.messages}!"
    end
  end

  def update
  end

  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content, :user_id, :entry_id)
    end
end
