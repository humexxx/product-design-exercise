module Posts
  class BookmarksController < ApplicationController
    before_action :set_post
    before_action :set_bookmark, only: [ :move_up, :move_down ]

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

    def move_up
      @bookmark.move_higher!
      set_homepage_bookmarks

      respond_to do |format|
        format.turbo_stream { render_homepage_bookmarks }
        format.html { redirect_back fallback_location: root_path }
      end
    end

    def move_down
      @bookmark.move_lower!
      set_homepage_bookmarks

      respond_to do |format|
        format.turbo_stream { render_homepage_bookmarks }
        format.html { redirect_back fallback_location: root_path }
      end
    end

    private

    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_bookmark
      @bookmark = @post.bookmarks.sole
    end

    def set_homepage_bookmarks
      @bookmarks = Bookmark.posts.includes(:bookmarkable).ordered
    end

    def render_homepage_bookmarks
      render turbo_stream: turbo_stream.update(
        "homepage_bookmarks",
        partial: "pages/bookmarks_list",
        locals: { bookmarks: @bookmarks }
      )
    end
  end
end
