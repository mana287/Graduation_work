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
    assert_difference("Article.count", 1) do
      post articles_url, params: {
        article: {
          title: "テスト投稿",
          body: "本文",
          kind: "shop",
          extra_info: "自由欄"
        }
      }
    end
    assert_redirected_to articles_url
  end
end
