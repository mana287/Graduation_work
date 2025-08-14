class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id  # 登録後に即ログイン
      redirect_to articles_path, notice: "登録しました。ようこそ！"
    else
      render :new, status: :unprocessable_entity
    end    
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
