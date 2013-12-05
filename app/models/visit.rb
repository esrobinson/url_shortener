class Visit < ActiveRecord::Base
  validates :user_id, :shortened_url_id, :presence => true
  attr_accessible :user_id, :shortened_url_id

  belongs_to(
  :user,
  :class_name => "User",
  :foreign_key => :user_id,
  :primary_key => :id
  )

  belongs_to(
  :shortened_url,
  :class_name => "ShortenedUrl",
  :foreign_key => :shortened_url_id,
  :primary_key => :id
  )

  def self.record_visit!(user, shortened_url)
    visit = Visit.new({
      :user_id => user.id,
      :shortened_url_id => shortened_url.id
    }).save!
    visit
  end
end
