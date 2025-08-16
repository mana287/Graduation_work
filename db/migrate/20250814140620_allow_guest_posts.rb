class AllowGuestPosts < ActiveRecord::Migration[8.0]
  def change
    change_column_null :articles, :user_id, true
    add_column :articles, :guest_name,  :string
  end
end
