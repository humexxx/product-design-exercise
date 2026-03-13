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
end
