class ArticlesController < ApplicationController
  # before_action :require_login, only: %i[new create]
  before_action :set_article, only: [ :show ]

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

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    # ★ guest_name を許可する（guest_email を使わないなら不要）
    params.require(:article).permit(:title, :body, :kind, :extra_info, :image, :tag_names, :guest_name)
  end
end
