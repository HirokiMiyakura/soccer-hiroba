class SessionsController < ApplicationController
  def new
    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @germany = Article.where(topic: 'ブンデスリーガ').limit(2)
    @england = Article.where(topic: 'プレミアリーグ').limit(2)
    @spain = Article.where(topic: 'リーガエスパニョル').limit(2)
    @italy = Article.where(topic: 'セリエA').limit(2)
    @japan = Article.where(topic: 'Jリーグ').limit(2)
    @national = Article.where(topic: '日本代表').limit(2)

    @user = current_user

    @rankings = Article.popular.limit(5)

    if signed_in?
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5)
    end
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)

    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @rankings = Article.popular.limit(5)
    
  	if user && user.authenticate(params[:session][:password])
  	  sign_in user
  	  redirect_back_or user
  	else
  	  flash.now[:error] = 'メールアドレスもしくはパスワードが間違っているようです。'
  	  render 'new'
  	end

    if signed_in?
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5)
    end
  end

  def destroy
  	sign_out
  	redirect_to root_path
    flash[:success] = "ログアウトしました。"
    @user = current_user

    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @rankings = Article.popular.limit(5)

    if signed_in?
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5)
    end
  end
end
