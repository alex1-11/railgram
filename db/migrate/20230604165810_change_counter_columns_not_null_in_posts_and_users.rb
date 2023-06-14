class ChangeCounterColumnsNotNullInPostsAndUsers < ActiveRecord::Migration[7.0]
  def change
    Post.find_each do |post|
      Post.reset_counters(post.id, :likes)
      Post.reset_counters(post.id, :comments)
    end

    User.find_each do |user|
      User.reset_counters(user.id, :posts)
      User.reset_counters(user.id, :followers)
      User.reset_counters(user.id, :following)
    end

    change_column_null :posts, :likes_count, false
    change_column_null :posts, :comments_count, false
    change_column_null :users, :posts_count, false
    change_column_null :users, :followers_count, false
    change_column_null :users, :following_count, false
  end
end
