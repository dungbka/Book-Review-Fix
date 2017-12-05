class NotificationsController < ApplicationController
  def create
    notifi = Notification.create(params_notifi)
  end

  def params_notifi
    params.require(:notification).permit(:subscriber_id, :notifi_id, :status, :message)
  end

  def update_status
    notifications = Notification.where(subscriber_id: params[:notification][:user_id], status: false)
    notifications.each do |notifi|
      notifi.update_attributes(status: true)
    end
  end
end
