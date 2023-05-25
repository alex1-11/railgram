class AddCountersToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :posts_count, :bigint
    add_column :users, :followers_count, :bigint
    add_column :users, :following_count, :bigint
  end
end
