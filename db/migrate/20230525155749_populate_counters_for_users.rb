class PopulateCountersForUsers < ActiveRecord::Migration[7.0]
  def up
    User.find_each do |user|
      User.reset_counters(user.id, :posts)
      User.reset_counters(user.id, :followers)
      User.reset_counters(user.id, :following)
    end
  end

  def down
    # No need to rollback counters reset
  end
end
