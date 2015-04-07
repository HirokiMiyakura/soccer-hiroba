class ArticlesController < ApplicationController
  before_action :signed_in_user, only: [:new, :vote]

  def index
  	@articles = Article.all.paginate(page: params[:page], per_page: 20)

    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @germany = Article.where(topic: 'ブンデスリーガ').limit(2)
    @england = Article.where(topic: 'プレミアリーグ').limit(2)
    @spain = Article.where(topic: 'リーガエスパニョル').limit(2)
    @italy = Article.where(topic: 'セリエA').limit(2)
    @japan = Article.where(topic: 'Jリーグ').limit(2)
    @national = Article.where(topic: '日本代表').limit(2)

    @user = current_user

    @rankings = Article.popular.limit(5)
  end

  def new
  	@article = Article.new
  	@user = current_user

    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @germany = Article.where(topic: 'ブンデスリーガ').limit(2)
    @england = Article.where(topic: 'プレミアリーグ').limit(2)
    @spain = Article.where(topic: 'リーガエスパニョル').limit(2)
    @italy = Article.where(topic: 'セリエA').limit(2)
    @japan = Article.where(topic: 'Jリーグ').limit(2)
    @national = Article.where(topic: '日本代表').limit(2)
    @rankings = Article.popular.limit(5)
  end

  def show
  	@article = Article.find(params[:id])
  	@user = current_user
    @comment = Comment.new
    @comments = Comment.where(article_id: current_article)

    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @germany = Article.where(topic: 'ブンデスリーガ').limit(2)
    @england = Article.where(topic: 'プレミアリーグ').limit(2)
    @spain = Article.where(topic: 'リーガエスパニョル').limit(2)
    @italy = Article.where(topic: 'セリエA').limit(2)
    @japan = Article.where(topic: 'Jリーグ').limit(2)
    @national = Article.where(topic: '日本代表').limit(2)
    @rankings = Article.popular.limit(5)
  end

  def create
  	@article = current_user.articles.build(article_params)
  	if @article.save
  	  flash[:success] = "記事を投稿いたしました"
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
