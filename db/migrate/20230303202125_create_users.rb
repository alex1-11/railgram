class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, limit: 256
      t.string :password
      t.string :name, limit: 30

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :name, unique: true
  end
end
