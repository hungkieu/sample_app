class Micropost < ApplicationRecord
  belongs_to :user
  default_scope {order created_at: :desc}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost_content.max_length}
  validate  :picture_size

  private

  def picture_size
    errors.add :picture, t("warning.less_5MB") if picture.size > 5.megabytes
  end
end
