class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :thumbnail_url
      t.string :player_url

      t.timestamps
    end
  end
end
