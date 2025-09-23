# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  before_action :require_login
  before_action :set_support_request

  def create
    @message = @support_request.messages.new(message_params)
    @message.user = current_user

    if @message.save
      redirect_to support_request_path(@support_request), notice: "Nachricht gesendet."
    else
      redirect_to support_request_path(@support_request), alert: "Nachricht konnte nicht gesendet werden."
    end
  end

  private

  def set_support_request
    @support_request = SupportRequest.find(params[:support_request_id])

    # Benutzer darf nur eigene Anfragen oder als Admin/Supporter sehen
    unless @support_request.user == current_user || current_user.admin? || current_user.supporter?
      redirect_to root_path, alert: "Zugriff verweigert."
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
