class CommentsController < ApplicationController
  def new
    @comment = Comment.new
    @user = current_user
  end

  def create
  	@comment = Comment.new(comment_params)
  	if @comment.save
      flash[:success] = "コメントを投稿いたしました"
    end
  	redirect_to :back
  end


  private
    def comment_params
      params.require(:comment).permit(:body, :user_id, :article_id)
    end
end