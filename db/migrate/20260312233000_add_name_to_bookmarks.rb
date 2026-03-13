class AddNameToBookmarks < ActiveRecord::Migration[8.1]
  def change
    add_column :bookmarks, :name, :string
  end
end
