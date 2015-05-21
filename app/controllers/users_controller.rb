class UsersController < ApplicationController
  before_action :signed_in_user, only: [ :index, :edit, :update, :destroy, :following, :followers ]
  before_action :correct_user, only: [ :edit, :update ]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])

    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @rankings = Article.popular.limit(5)

    @user = current_user

  end

  def show
    @user = User.find(params[:id])
    @articles = @user.articles.paginate(page: params[:page])

    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @rankings = Article.popular.limit(5)

  end

  def new
    @user = User.new

    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @rankings = Article.popular.limit(5)

    if signed_in?
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5)
    end
  end

  def create

    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @rankings = Article.popular.limit(5)

    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "ようこそ【 さっかーひろば 】へ！ まずは上部の『 ヘルプ 』で使い方をチェックしてください！"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit

    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @rankings = Article.popular.limit(5)

    @user = current_user
    
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールが更新されました"
      redirect_to @user
    else
      render 'edit'
    end

    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @rankings = Article.popular.limit(5)

    if signed_in?
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5)
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_url
  end

  def following
    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @rankings = Article.popular.limit(5)

    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'


    if signed_in?
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5)
    end
  end

  def followers
    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @rankings = Article.popular.limit(5)
    
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:id])
    render 'show_follow'

    if signed_in?
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5)
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                      :password_confirmation, :avatar, :avatar_cache, :remove_avatar)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
