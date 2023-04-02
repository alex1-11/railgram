class ChangeImageDataColumnNotNullInPosts < ActiveRecord::Migration[7.0]
  def change
    change_column_null :posts, :image_data, false
  end
end
