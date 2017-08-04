class MessagesController < ApplicationController
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end

  def index
    @messages = @conversation.messages
    if @messages.length > 10
      @over_ten = true
      @messages = @messages[-10..-1]
    end

    if params[:m]
      @over_ten = false
      @messages = @conversation.messages
    end

    if @messages.last
      if @messages.last.user_id != current_user.id
        @messages.last.read = true
      end
    end

    @message = @conversation.messages.build

    if @conversation.recipient_id == current_user.id
      @recipient_user = User.find(@conversation.sender_id)
    else
      @recipient_user = User.find(@conversation.recipient_id)
    end
  end

  def create
    @message = @conversation.messages.build(message_params)
    if @message.save
      redirect_to conversation_messages_path(@conversation)
    else
      redirect_to conversation_messages_path(@conversation), alert: 'メッセージの送信ができませんでした。'
      # @messages = @conversation.messages
      # if @conversation.recipient_id == current_user.id
      #   @recipient_user = User.find(@conversation.sender_id)
      # else
      #   @recipient_user = User.find(@conversation.recipient_id)
      # end
      #
      # render 'index', { messages: @messages, recipient_user: @recipient_user }
    end
  end

  private
    def message_params
      params.require(:message).permit(:body, :user_id)
    end
end
