class PostsController < ApplicationController
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]

  def index
    @posts = Post.includes(:bookmarks).order(created_at: :desc)
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @post.assign_attributes(post_params)
    @bookmark&.assign_attributes(bookmark_params)

    if @post.valid? && bookmark_valid?
      ActiveRecord::Base.transaction do
        @post.save!
        @bookmark&.save!
      end

      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Post was successfully deleted."
  end

  private

  def set_post
    @post = Post.includes(:bookmarks).find(params[:id])
    @bookmark = @post.bookmarks.first
  end

  def post_params
    params.expect(post: [ :title, :body ])
  end

  def bookmark_params
    return {} unless params[:bookmark]

    params.expect(bookmark: [ :name ])
  end

  def bookmark_valid?
    return true unless @bookmark

    @bookmark.valid?
  end
end
