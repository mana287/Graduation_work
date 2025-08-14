class Article < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  enum :kind, { shop: 0, product: 1 } # 店舗/商品

  # 後で acts-as-taggable-on 等を入れるまでの“受け口”
  attr_accessor :tag_names

  validates :title, presence: true, length: { maximum: 120 }
  validates :body,  presence: true

  validate :image_type_and_size

  private
  def image_type_and_size
    return unless image.attached?

    unless image.content_type.in?(%w[image/png image/jpeg image/jpg image/webp])
      errors.add(:image, "はPNG/JPEG/WEBPのみアップロードできます")
    end
    if image.byte_size > 5.megabytes
      errors.add(:image, "は5MB以下にしてください")
    end
  end
end
