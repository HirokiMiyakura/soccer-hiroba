class UsersController < ApplicationController
  before_action :signed_in_user, only: [ :index, :edit, :update, :destroy, :following, :followers ]
  before_action :correct_user, only: [ :edit, :update ]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])

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

  def show
    @user = User.find(params[:id])
    @articles = @user.articles.paginate(page: params[:page])

    @latestarticles = Article.all.order(created_at: :desc).limit(5)
    @germany = Article.where(topic: 'ブンデスリーガ').limit(2)
    @england = Article.where(topic: 'プレミアリーグ').limit(2)
    @spain = Article.where(topic: 'リーガエスパニョル').limit(2)
    @italy = Article.where(topic: 'セリエA').limit(2)
    @japan = Article.where(topic: 'Jリーグ').limit(2)
    @national = Article.where(topic: '日本代表').limit(2)

    @rankings = Article.popular.limit(5)
  end

  def new
    @user = User.new
  end

  def create
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
    @germany = Article.where(topic: 'ブンデスリーガ').limit(2)
    @england = Article.where(topic: 'プレミアリーグ').limit(2)
    @spain = Article.where(topic: 'リーガエスパニョル').limit(2)
    @italy = Article.where(topic: 'セリエA').limit(2)
    @japan = Article.where(topic: 'Jリーグ').limit(2)
    @national = Article.where(topic: '日本代表').limit(2)

    @user = current_user

    @rankings = Article.popular.limit(5)
    
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールが更新されました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:id])
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                      :password_confirmation, :avatar, :avatar_cache)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
