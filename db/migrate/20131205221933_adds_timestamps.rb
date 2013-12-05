class AddsTimestamps < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.timestamps
    end

    change_table :shortened_urls do |t|
      t.timestamps
    end

    change_table :visits do |t|
      t.timestamps
    end
  end
end
