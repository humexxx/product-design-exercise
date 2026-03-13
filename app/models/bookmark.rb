class Bookmark < ApplicationRecord
  belongs_to :bookmarkable, polymorphic: true

  scope :ordered, -> { order(:position, :created_at) }
  scope :posts, -> { where(bookmarkable_type: "Post") }

  validates :position, presence: true, uniqueness: true

  before_validation :assign_position, on: :create

  def move_higher!
    move_by(-1)
  end

  def move_lower!
    move_by(1)
  end

  private

  def assign_position
    self.position ||= (self.class.maximum(:position) || 0) + 1
  end

  def move_by(offset)
    bookmarks = self.class.ordered.to_a
    current_index = bookmarks.index { |bookmark| bookmark.id == id }
    target_index = current_index.to_i + offset

    return false if current_index.nil?
    return false if target_index.negative? || target_index >= bookmarks.length

    swap_positions_with(bookmarks[target_index])
  end

  def swap_positions_with(other)
    transaction do
      current_position = position
      other_position = other.position
      temporary_position = (self.class.maximum(:position) || 0) + 1

      update_columns(position: temporary_position)
      other.update_columns(position: current_position)
      update_columns(position: other_position)
    end
  end
end
