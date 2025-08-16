// app/javascript/kind_extra_info.js
function setupKindDrivenExtraInfo() {
  const kindSelect = document.getElementById("article_kind");
  const label = document.getElementById("extra_info_label");
  const textarea = document.getElementById("article_extra_info");
  if (!kindSelect || !label || !textarea) return;

  const update = () => {
    const isShop = kindSelect.value === "shop";
    const shopLabel = textarea.dataset.shopLabel || "店舗情報（任意）";
    const productLabel = textarea.dataset.productLabel || "商品情報（任意）";
    const shopPh = textarea.dataset.shopPh || "営業時間、住所、最寄り駅、リンクなど";
    const productPh = textarea.dataset.productPh || "価格、購入場所、URL、型番など";

    label.textContent = isShop ? shopLabel : productLabel;
    textarea.placeholder = isShop ? shopPh : productPh;
  };

  update();
  kindSelect.addEventListener("change", update);
}

// Turbo対応 + 通常DOMロードの両方にフック
document.addEventListener("turbo:load", setupKindDrivenExtraInfo);
document.addEventListener("DOMContentLoaded", setupKindDrivenExtraInfo);
