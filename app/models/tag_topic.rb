class TagTopic < ActiveRecord::Base
  validates :tag, :presence => true, :uniqueness => true
  attr_accessible :tag

  has_many(
  :taggings,
  :class_name => "Tagging",
  :foreign_key => :tag_topic_id,
  :primary_key => :id
  )

  has_many(:shortened_urls, :through => :taggings, :source => :shortened_urls)


  def most_popular_urls(n)
    ShortenedUrl.joins(:visits, :tags)
                .where("tag_topics.id = ?", self.id)
                .group("shortened_urls.id")
                .order("COUNT(*) DESC")
                .limit(n)
  end
end