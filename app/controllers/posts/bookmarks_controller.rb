module Posts
  class BookmarksController < ApplicationController
    before_action :set_post

    def create
      @bookmark = @post.bookmarks.create!
      set_homepage_bookmarks

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post }
      end
    end

    def destroy
      @post.bookmarks.destroy_all
      set_homepage_bookmarks

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post }
      end
    end

    private

    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_homepage_bookmarks
      @bookmarks = Bookmark.includes(:bookmarkable)
                           .where(bookmarkable_type: "Post")
                           .order(created_at: :desc)
    end
  end
end
