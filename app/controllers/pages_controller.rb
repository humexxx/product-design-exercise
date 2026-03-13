class PagesController < ApplicationController
  def home
    @total_posts = Post.count
    @recent_posts = Post.includes(:bookmarks).order(created_at: :desc).limit(3)
    @bookmarks = Bookmark.includes(:bookmarkable)
                         .where(bookmarkable_type: "Post")
                         .order(created_at: :desc)
  end
end
