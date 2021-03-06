class User < ActiveRecord::Base
  validates :email, :presence => true, :uniqueness => true
  validates :password, :presence => true, :on => :create

  has_secure_password
  attr_accessible :email, :password, :password_confirmation

  has_many(
    :submitted_urls,
    :class_name => "ShortenedUrl",
    :foreign_key => :submitter_id,
    :primary_key => :id
  )

  has_many(
    :visits,
    :class_name => "Visit",
    :foreign_key => :user_id,
    :primary_key => :id
  )

  has_many(
    :visited_urls,
    :through => :visits,
    :source => :shortened_url,
    :uniq => :true
  )

end