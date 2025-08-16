require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as(@user)
  end

  test "should get index" do
    get articles_url
    assert_response :success
  end

  test "should create article" do
    sign_in_as(@user)
    assert_difference("Article.count", 1) do
      post articles_url, params: {
        article: {
          title: "テスト投稿",
          body: "本文",
          kind: "shop",
          extra_info: "自由欄"
          # 画像は省略可。使うなら↓
          # image: Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/files/sample.jpg"), "image/jpeg")
        }
      }
    end
    assert_redirected_to articles_url
  end
end
