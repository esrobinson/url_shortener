class ShortenedUrl < ActiveRecord::Base
  attr_accessible :short_url, :long_url, :submitter_id

  validates :short_url, :presence => true, :uniqueness => true
  validates :submitter_id, :presence => true
  validates :long_url, :presence => true, :length => { :maximum => 255 }
  validate :rate_limiter

  belongs_to(
    :submitter,
    :class_name => "User",
    :foreign_key => :submitter_id,
    :primary_key => :id
  )

  has_many(
    :visits,
    :class_name => "Visit",
    :foreign_key => :shortened_url_id,
    :primary_key => :id
  )

  has_many(
    :taggings,
    :class_name => "Tagging",
    :foreign_key => :shortened_url_id,
    :primary_key => :id
  )

  has_many(:visitors, :through => :visits, :source => :user, :uniq => true)

  has_many(:tags, :through => :taggings, :source => :tag_topic)

  def self.random_code
    random_code = SecureRandom::urlsafe_base64
    self.random_code unless ShortenedUrl.find_by_short_url(random_code).nil?
    random_code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    short_url = self.random_code[0..4]
    shortened = ShortenedUrl.new({
      :short_url => short_url,
      :long_url => long_url,
      :submitter_id => user.id
      })
    shortened.save!
    shortened
  end

  def num_clicks
    self.visits.count #Is there a better way to do it
  end

  def num_uniques
    self.visits.count(:user_id, :distinct => :true)
  end

  def num_recent_uniques
    self.visits.where("created_at >= ?", 10.minutes.ago)
  end

  private

  def rate_limiter
    user = User.find(submitter_id)

    if user.submitted_urls.where("created_at >= ?", 1.minute.ago).count >= 5
      errors[:user] << 'has submitted too many times in last minute.'
    end
  end

end
