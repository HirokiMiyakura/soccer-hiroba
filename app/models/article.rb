class Article < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true
  has_reputation :votes, source: :user, aggregated_by: :sum
  #has_many: comments, dependent: :destroy

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids})",
          user_id: user.id).limit(2)
  end

  def self.popular
    reorder('votes desc').find_with_reputation(:votes, :all)
  end

end
