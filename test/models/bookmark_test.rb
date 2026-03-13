require "test_helper"

class BookmarkTest < ActiveSupport::TestCase
  test "assigns the next position when creating bookmarks" do
    first_post = Post.create!(title: "First", body: "Body")
    second_post = Post.create!(title: "Second", body: "Body")

    first_bookmark = first_post.bookmarks.create!
    second_bookmark = second_post.bookmarks.create!

    assert_equal 1, first_bookmark.position
    assert_equal 2, second_bookmark.position
  end

  test "move_higher swaps positions with the previous bookmark" do
    first_bookmark = Post.create!(title: "First", body: "Body").bookmarks.create!
    second_bookmark = Post.create!(title: "Second", body: "Body").bookmarks.create!

    second_bookmark.move_higher!

    assert_equal [ second_bookmark.id, first_bookmark.id ], Bookmark.ordered.pluck(:id)
  end

  test "move_lower swaps positions with the next bookmark" do
    first_bookmark = Post.create!(title: "First", body: "Body").bookmarks.create!
    second_bookmark = Post.create!(title: "Second", body: "Body").bookmarks.create!

    first_bookmark.move_lower!

    assert_equal [ second_bookmark.id, first_bookmark.id ], Bookmark.ordered.pluck(:id)
  end

  test "display_name falls back to the post title" do
    bookmark = Post.create!(title: "Fallback title", body: "Body").bookmarks.create!

    assert_equal "Fallback title", bookmark.display_name
  end

  test "normalizes blank names to nil" do
    bookmark = Post.create!(title: "Original title", body: "Body").bookmarks.create!(name: "   ")

    assert_nil bookmark.name
    assert_equal "Original title", bookmark.display_name
  end

  test "uses the custom name when present" do
    bookmark = Post.create!(title: "Original title", body: "Body").bookmarks.create!(name: "Read this later")

    assert_equal "Read this later", bookmark.display_name
  end

  test "compacts positions after a bookmark is removed" do
    first_bookmark = Post.create!(title: "First", body: "Body").bookmarks.create!
    second_bookmark = Post.create!(title: "Second", body: "Body").bookmarks.create!
    third_bookmark = Post.create!(title: "Third", body: "Body").bookmarks.create!

    second_bookmark.destroy!
    Bookmark.compact_positions!

    assert_equal [ [ first_bookmark.id, 1 ], [ third_bookmark.id, 2 ] ], Bookmark.ordered.pluck(:id, :position)
  end
end
