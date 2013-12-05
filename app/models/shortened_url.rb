class ShortenedUrl < ActiveRecord::Base
  attr_accessible :short_url, :long_url, :submitter_id

  validates :short_url, :presence => true, :uniqueness => true
  validates :submitter_id, :presence => true

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

  has_many(:visitors, :through => :visits, :source => :user, :uniq => true)

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
end
