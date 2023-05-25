class PopulateCountersForPosts < ActiveRecord::Migration[7.0]
  def up
    Post.find_each do |post|
      Post.reset_counters(post.id, :likes)
      Post.reset_counters(post.id, :comments)
    end
  end

  def down
    # No need to rollback counters reset
  end
end
