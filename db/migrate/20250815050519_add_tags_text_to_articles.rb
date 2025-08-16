class AddTagsTextToArticles < ActiveRecord::Migration[8.0]
  def change
    add_column :articles, :tags_text, :text
  end
end
