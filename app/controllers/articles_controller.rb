class ArticlesController < ApplicationController
  before_action :signed_in_user, only: [:new, :vote]

  def index
  	@articles = Article.all.paginate(page: params[:page], per_page: 20)

    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @rankings = Article.popular.limit(5)

    @user = current_user
  end

  def new
  	@article = Article.new
  	@user = current_user

    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @rankings = Article.popular.limit(5)
  end

  def edit
    @article = Article.find(params[:id])
    @user = current_user

    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @rankings = Article.popular.limit(5)
  end

  def show
  	@article = Article.find(params[:id])
  	@user = current_user
    @comment = Comment.new
    @comments = Comment.where(article_id: current_article)

    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @rankings = Article.popular.limit(5)
  end

  def create
    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @rankings = Article.popular.limit(5)

    @user = current_user
  	@article = current_user.articles.build(article_params)
  	if @article.save
  	  flash[:success] = "記事を投稿いたしました"
  	  redirect_to root_url
  	else
  	  render 'new'
  	end
  end

  def update
    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @rankings = Article.popular.limit(5)

    @article = Article.find(params[:id])
    if @article.update_attributes(article_params)
      flash[:success] = "投稿が更新されました"
      redirect_to @article
    else
      render 'edit'
    end

  end

  def vote
    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @rankings = Article.popular.limit(5)

    value = params[:type] == "up" ? 1 : -1
    @article = Article.find(params[:id])
    @article.add_or_update_evaluation(:votes, value, current_user)
    redirect_to :back, notice: "Thank you for voting!"

  end

  def destroy
    Article.find(params[:id]).destroy
    flash[:success] = "投稿が削除されました"
    redirect_to root_url
  end

    private

      def article_params
        params.require(:article).permit(
      	  :user_id, :title, :topic, :body, :votes
        )
      end
end
