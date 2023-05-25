class AddCountersToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :likes_count, :bigint
    add_column :posts, :comments_count, :bigint
  end
end
