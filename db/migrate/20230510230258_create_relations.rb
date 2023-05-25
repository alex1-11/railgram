class CreateRelations < ActiveRecord::Migration[7.0]
  def change
    create_table :relations do |t|
      t.bigint :follower_id
      t.bigint :followed_id

      t.timestamps
    end

    add_index :relations, :follower_id
    add_index :relations, :followed_id
    add_index :relations, %i[follower_id followed_id], unique: true
  end
end
