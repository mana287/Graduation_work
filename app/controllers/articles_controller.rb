class ArticlesController < ApplicationController
  # before_action :require_login, only: %i[new create]
  before_action :set_article,    only: %i[show edit update destroy]
  before_action :require_owner!, only: %i[edit update destroy]

  def index
    @articles = Article
      .includes(:user)
      .with_attached_image
      .order(created_at: :desc)
  end

  def show
  end

  def new
    @article = Article.new
  end

  def create
    Rails.logger.info "[ARTICLE_PARAMS] #{params.to_unsafe_h.except('authenticity_token', 'commit').tap { |h| h['article']&.delete('image') }.inspect}"

    attrs = article_params.to_h
    if current_user
      attrs.delete("guest_name")
      @article = current_user.articles.build(attrs)
    else
      @article = Article.new(attrs)
    end

    if @article.save
      redirect_to articles_path, notice: "記事を投稿しました"
    else
      Rails.logger.info("[ARTICLE_SAVE_ERRORS] #{@article.errors.full_messages.inspect}")
      flash.now[:alert] = @article.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    attrs = article_params.to_h
    attrs.delete("guest_name") if current_user # ログイン中は guest_name を無視

    if @article.update(attrs)
      redirect_to @article, notice: "記事を更新しました"
    else
      flash.now[:alert] = @article.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # “自分の投稿のみ削除可”。ゲスト投稿（user_id が nil）は削除リンクを出さない想定
    unless current_user && @article.user_id.present? && @article.user_id == current_user.id
      redirect_to @article, alert: "この投稿は削除できません。"
      return
    end

    @article.destroy!
    redirect_to articles_path, notice: "記事を削除しました。"
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def require_owner!
    # user_id がある記事について、本人のみ編集/削除を許可する（ゲスト投稿は不可）
    unless current_user && @article.user_id.present? && @article.user_id == current_user.id
      redirect_to @article, alert: "この投稿は編集・削除できません。"
    end
  end

  def article_params
    # ★ guest_name を許可する（guest_email を使わないなら不要）
    params.require(:article).permit(:title, :body, :kind, :extra_info, :image, :tag_names, :guest_name)
  end
end
