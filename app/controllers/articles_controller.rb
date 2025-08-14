class ArticlesController < ApplicationController
  def index
    @articles = Article.includes(:user, image_attachment: :blob).order(created_at: :desc)
  end
end
