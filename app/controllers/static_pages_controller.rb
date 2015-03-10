class StaticPagesController < ApplicationController
  def home
  	@articles = Article.all.order(created_at: :desc).limit(5)
  	@germany = Article.where(topic: 'ブンデスリーガ').limit(2)
  	@england = Article.where(topic: 'プレミアリーグ').limit(2)
  	@spain = Article.where(topic: 'リーガエスパニョル').limit(2)
  	@italy = Article.where(topic: 'セリエA').limit(2)

  	@user = current_user

    @rankings = Article.find_with_reputation(:votes, :all, order: 'votes: :desc').limit(5)

    if signed_in?
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5)
    end
  end

  def help
  end
end
