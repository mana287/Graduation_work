class Article < ApplicationRecord
  belongs_to :user, optional: true
  has_one_attached :image

  enum :kind, { shop: 0, product: 1 } # 店舗/商品

  # 後で acts-as-taggable-on 等を入れるまでの“受け口”
  attr_accessor :tag_names

  before_validation :copy_tag_names_to_tags_text
  before_validation :ensure_guest_name

  validates :title, presence: true, length: { maximum: 120 }
  validates :body,  presence: true

  # ゲスト投稿用チェック
  # validate :author_presence

  validate :image_type_and_size

  # 表示用：投稿者名
  def author_name
    user&.name.presence || guest_name.presence || "ゲスト"
  end

  private

  def copy_tag_names_to_tags_text
    self.tags_text = tag_names if tag_names.present?
  end

  def ensure_guest_name
    self.guest_name = "ゲスト" if user_id.nil? && guest_name.blank?
  end

  # def author_presence
  #   if user.nil? && guest_name.blank?
  #    errors.add(:guest_name, "を入力してください（未ログインで投稿する場合）")
  #  end
  # end

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
