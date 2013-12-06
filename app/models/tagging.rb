class Tagging < ActiveRecord::Base
  validates :tag_topic_id, :uniqueness => {:scope => :shortened_url_id}
  validates :tag_topic_id, :shortened_url_id, :presence => :true

  attr_accessible :tag_topic_id, :shortened_url_id

  belongs_to(
    :tag_topic,
    :class_name => "TagTopic",
    :foreign_key => :tag_topic_id,
    :primary_key => :id
  )

  belongs_to(
    :shortened_url,
    :class_name => "ShortenedUrl",
    :foreign_key => :shortened_url_id,
    :primary_key => :id,
  )

end
