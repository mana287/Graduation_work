class ArticlesController < ApplicationController
  before_action :require_login, only: %i[new create]

  def index
    @articles = Article
      .includes(:user)
      .with_attached_image
      .order(created_at: :desc)
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      redirect_to articles_path, notice: "記事を投稿しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def article_params
    params.require(:article).permit(:title, :body, :kind, :extra_info, :image, :tag_names)
  end
end
