require "test_helper"

class BookmarkRenamingTest < ActionDispatch::IntegrationTest
  test "renames a bookmark" do
    post_record = Post.create!(title: "Original title", body: "Body")
    bookmark = post_record.bookmarks.create!

    patch post_bookmark_path(post_record), params: { bookmark: { name: "Read this tonight" } }, as: :turbo_stream

    assert_equal "Read this tonight", bookmark.reload.name
  end
end
