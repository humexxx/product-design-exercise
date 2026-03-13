require "test_helper"

class BookmarkRenamingTest < ActionDispatch::IntegrationTest
  test "renames a bookmark" do
    post_record = Post.create!(title: "Original title", body: "Body")
    bookmark = post_record.bookmarks.create!

    patch post_bookmark_path(post_record), params: { bookmark: { name: "Read this tonight" } }, as: :turbo_stream

    assert_equal "Read this tonight", bookmark.reload.name
  end

  test "show page displays the custom bookmark name" do
    post_record = Post.create!(title: "Original title", body: "Body")
    post_record.bookmarks.create!(name: "Read this tonight")

    get post_path(post_record)

    assert_response :success
    assert_match "Saved as: Read this tonight", response.body
  end

  test "edit page includes bookmark settings when bookmarked" do
    post_record = Post.create!(title: "Original title", body: "Body")
    post_record.bookmarks.create!(name: "Read this tonight")

    get edit_post_path(post_record)

    assert_response :success
    assert_match "Bookmark name", response.body
  end

  test "edit page does not show bookmark controls when post is not bookmarked" do
    post_record = Post.create!(title: "Original title", body: "Body")

    get edit_post_path(post_record)

    assert_response :success
    assert_no_match "Bookmark name", response.body
  end

  test "edit post updates the bookmark name in the same form" do
    post_record = Post.create!(title: "Original title", body: "Body")
    bookmark = post_record.bookmarks.create!(name: "Read this tonight")

    patch post_path(post_record), params: {
      post: { title: "Updated title", body: "Updated body" },
      bookmark: { name: "Read this tomorrow" }
    }

    assert_redirected_to post_path(post_record)
    assert_equal "Updated title", post_record.reload.title
    assert_equal "Read this tomorrow", bookmark.reload.name
  end
end
