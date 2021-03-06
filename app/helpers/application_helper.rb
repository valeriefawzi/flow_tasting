module ApplicationHelper
  def bootstrap_class_for(flash_type)
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }.fetch(flash_type.to_sym, nil)
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do 
        concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
        concat message 
      end)
    end
    nil
  end

  def authenticate_guest(email, event_key)
    user = User.find_by_email(email)
    return nil if user.nil?
    event = Event.find_by_event_key(event_key)
    return nil if event.nil?
    return user if event.host == user #allow host to login
    guest = Guest.where(user: user, event: event).first 
    return guest.try(:user)
  end

  #This is not defined as current_user to avoid any conflicts with devise#current_user.
  def current_guest
    @guest ||= User.find(session[:guest_id]) if session[:guest_id]
  end

  def current_event
    @event ||= Event.find_by_event_key(session[:event_key]) if session[:event_key]
  end

end
