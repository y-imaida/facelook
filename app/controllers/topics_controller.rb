class TopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  def index
    @topics = Topic.where(user_id: current_user.id).order(updated_at: :desc)
    @user = current_user

    @friends = []
    current_user.followed_users.each do |followed|
      if current_user.followers.find(followed.id)
        @friends << followed
      end
    end
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
