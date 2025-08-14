class Article < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  enum :kind, { shop: 0, product: 1 } # 店舗/商品

  # 後で acts-as-taggable-on 等を入れるまでの“受け口”
  attr_accessor :tag_names

  validates :title, presence: true, length: { maximum: 120 }
  validates :body,  presence: true

  validate :validate_image_type_and_size

  def validate_image_type_and_size
    return unless image.attached?

    acceptable_types = %w[image/png image/jpg image/jpeg image/webp]
    unless acceptable_types.include?(image.blob.content_type)
      errors.add(:image, "は JPG/PNG/WebP のみアップロードできます")
    end

    if image.blob.byte_size > 5.megabytes
      errors.add(:image, "は 5MB 以下にしてください")
    end
  end
end
