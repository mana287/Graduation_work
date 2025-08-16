class CreateArticles < ActiveRecord::Migration[8.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.integer :kind
      t.text :extra_info
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
