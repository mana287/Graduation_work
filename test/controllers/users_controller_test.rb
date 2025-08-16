require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    # /signup を使ってもOK: get signup_url
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count", 1) do
      post users_url, params: {
        user: {
          name: "New User",
          # fixtures と被らないメールを使う
          email: "new_#{SecureRandom.hex(4)}@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end
    assert_redirected_to articles_url
  end
end
