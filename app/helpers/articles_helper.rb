module ArticlesHelper
    def display_author(article)
      article.user&.name || article.guest_name || "ゲスト"
    end

    def kind_label(article)
      article.shop? ? "店舗情報" : "商品情報"
    end
end
