class StaticPagesController < ApplicationController
  def home
  	@articles = Article.all.limit(5)
  	@germany = Article.where(topic: 'ブンデスリーガ')
  	@england = Article.where(topic: 'プレミアリーグ')
  	@spain = Article.where(topic: 'リーガエスパニョル')
  	@italy = Article.where(topic: 'セリエA')

  	@user = current_user

    if signed_in?
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5)
    end
  end

  def help
  end
end
