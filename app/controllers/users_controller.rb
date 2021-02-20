class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
    @mutual = @user.mutual_friends
    puts "Helo mutual #{@mutual}"
    @mutual2 = current_user.mutual_friends
    puts "Helo mutual2 #{@mutual2}"
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
