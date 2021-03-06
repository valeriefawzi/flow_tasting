module Events
  class SessionsController < ApplicationController

    def new
      session[:guest_id] = nil
    end

    def create
      guest = authenticate_guest(params[:email], params[:event_key])
      if guest
        session[:guest_id] = guest.id
        session[:event_key] = params[:event_key]
        redirect_to events_url
      else
        flash[:error] = "It looks like you haven't been invited for the event. Please contact the event's host for more details."
        redirect_to new_events_session_url
      end
    end

    def destroy
      session[:guest_id] = nil
      redirect_to new_events_session_url
    end

  end
end