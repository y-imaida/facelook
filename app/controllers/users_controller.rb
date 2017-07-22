class UsersController < ApplicationController
  def index
    @users = User.all.order(:name)
  end

  def show
    @user = User.find(params[:id])

    if @user.id == current_user.id
      redirect_to topics_path
    end

    @topics = Topic.where(user_id: @user.id).order(updated_at: :desc)

    @friends = []
    @user.followers.each do |follower|
      if @user.following?(follower)
        @friends << follower
      end
    end
    @friends.sort!
  end
end
