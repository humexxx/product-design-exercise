module Posts
  class BookmarksController < ApplicationController
    before_action :set_post
    before_action :set_bookmark, only: [ :show, :edit, :update, :destroy, :move_up, :move_down ]

    def show
      set_homepage_bookmarks

      respond_to do |format|
        format.turbo_stream { render_homepage_bookmarks }
        format.html { redirect_back fallback_location: root_path }
      end
    end

    def create
      @bookmark = @post.bookmarks.create!
      set_homepage_bookmarks

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post }
      end
    end

    def destroy
      @bookmark.destroy!
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

    def edit
      set_homepage_bookmarks
      @editing_bookmark = @bookmark

      respond_to do |format|
        format.turbo_stream { render_homepage_bookmarks }
        format.html { redirect_back fallback_location: root_path }
      end
    end

    def update
      if @bookmark.update(bookmark_params)
        set_homepage_bookmarks

        respond_to do |format|
          format.turbo_stream { render_homepage_bookmarks }
          format.html { redirect_back fallback_location: root_path, notice: "Bookmark renamed." }
        end
      else
        set_homepage_bookmarks
        @editing_bookmark = @bookmark

        respond_to do |format|
          format.turbo_stream { render_homepage_bookmarks status: :unprocessable_entity }
          format.html { redirect_back fallback_location: root_path, alert: @bookmark.errors.full_messages.to_sentence }
        end
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

    def bookmark_params
      params.expect(bookmark: [ :name ])
    end

    def set_homepage_bookmarks
      @bookmarks = Bookmark.posts.includes(:bookmarkable).ordered
    end

    def render_homepage_bookmarks(status: :ok)
      render turbo_stream: turbo_stream.update(
        "homepage_bookmarks",
        partial: "pages/bookmarks_list",
        locals: { bookmarks: @bookmarks, editing_bookmark: @editing_bookmark }
      ), status: status
    end
  end
end
