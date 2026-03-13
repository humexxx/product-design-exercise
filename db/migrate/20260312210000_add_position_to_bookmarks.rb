class AddPositionToBookmarks < ActiveRecord::Migration[8.1]
  class MigrationBookmark < ApplicationRecord
    self.table_name = "bookmarks"
  end

  def up
    add_column :bookmarks, :position, :integer

    MigrationBookmark.reset_column_information

    MigrationBookmark.order(:created_at, :id).each.with_index(1) do |bookmark, index|
      bookmark.update_columns(position: index)
    end

    change_column_null :bookmarks, :position, false
    add_index :bookmarks, :position, unique: true
  end

  def down
    remove_index :bookmarks, :position
    remove_column :bookmarks, :position
  end
end
