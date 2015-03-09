class Article < ActiveRecord::Base
  belongs_to :user
  #default_scope -> { order('created_at DESC') }
  validates :body, presence: true
  validates :user_id, presence: true

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids})",
          user_id: user.id).limit(2)
  end
end
