class TopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  def index
    @topics = Topic.where(user_id: current_user.id).order(updated_at: :desc)
    @user = current_user

    @friends = []
    @friend_request_user = []
    current_user.followers.each do |follower|
      if current_user.following?(follower)
        @friends << follower
      else
        @friend_request_user << follower
      end
    end
    @friends.sort!
    @friend_request_user.sort!
  end

  def show
    @comment = @topic.comments.build
    @comments = @topic.comments

    Notification.find(params[:notification_id]).update(read: true) if params[:notification_id]
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)
    @topic.user_id = current_user.id
    if @topic.save
      redirect_to topics_path, notice: "トピックを投稿しました！"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @topic.update(topic_params)
      redirect_to topics_path, notice: "トピックの内容を変更しました！"
    else
      render 'edit'
    end
  end

  def destroy
    @topic.destroy
    redirect_to topics_path, notice: "トピックを削除しました！"
  end

  private
    def topic_params
      params.require(:topic).permit(:content, :picture)
    end

    def set_topic
      @topic = Topic.find(params[:id])
    end
end
