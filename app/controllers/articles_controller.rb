class ArticlesController < ApplicationController
  before_action :signed_in_user, only: [:new]

  def index
  	@articles = Article.all
  end

  def new
  	@article = Article.new
  	@user = current_user
  end

  def show
  	@article = Article.find(params[:id])
  	@user = current_user
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

    private

      def article_params
        params.require(:article).permit(
      	  :user_id, :title, :topic, :body
        )
      end
end
