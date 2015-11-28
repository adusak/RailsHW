class AddPostCountToTags < ActiveRecord::Migration
  def change
    add_column :tags, :post_count, :integer
  end
end
