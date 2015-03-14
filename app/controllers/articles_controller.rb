class ArticlesController < ApplicationController
  before_action :signed_in_user, only: [:new, :vote]

  def index
  	@articles = Article.all.paginate(page: params[:page], per_page: 20)
  end

  def new
  	@article = Article.new
  	@user = current_user
  end

  def show
  	@article = Article.find(params[:id])
  	@user = current_user
    @comment = Comment.new
    @comments = Comment.where(article_id: current_article)
  end

  def create
  	@article = current_user.articles.build(article_params)
  	if @article.save
  	  flash[:success] = "作成しました"
  	  redirect_to root_url
  	else
  	  render :new
  	end
  end

  def vote
    value = params[:type] == "up" ? 1 : -1
    @article = Article.find(params[:id])
    @article.add_or_update_evaluation(:votes, value, current_user)
    redirect_to :back, notice: "Thank you for voting!"
  end

    private

      def article_params
        params.require(:article).permit(
      	  :user_id, :title, :topic, :body, :votes
        )
      end
end
