class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.content.max_size}
  validate :picture_size
  default_scope ->{order created_at: :desc}
  mount_uploader :picture, PictureUploader

  private

  def picture_size
    return unless picture.size > 5.megabytes
    errors.add :picture, t("layouts.flash.less_5mb")
  end
end
