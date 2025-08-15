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
    attrs = article_params
    if current_user
      # ログイン中は guest_name を無視（なりすまし防止）
      attrs = attrs.except(:guest_name)
      @article = current_user.articles.build(attrs)
    else
      # ゲスト投稿（user_id は nil のまま、guest_name を使う）
      @article = Article.new(attrs)
    end

    if @article.save
      redirect_to articles_path, notice: "記事を投稿しました"
    else
      flash.now[:alert] = @article.errors.full_messages.to_sentence
      Rails.logger.info("[ARTICLE_SAVE_ERRORS] #{@article.errors.full_messages.inspect}")
      render :new, status: :unprocessable_content
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
