class RemovePasswordFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :password, :string, if_exists: true
  end
end
