class AddsTagTopicAndTaggings < ActiveRecord::Migration

  def change
    create_table :tag_topics do |t|
      t.string :tag

      t.timestamps
    end

    create_table :taggings do |t|
      t.integer :tag_topic_id
      t.integer :shortened_url_id

      t.timestamps
    end

    add_index :taggings, :tag_topic_id
  end

end
