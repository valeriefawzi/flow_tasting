class ScoresController < ApplicationController
  
  before_filter :require_guest

  def index
    @wines = WinePackage.wine_list(current_event.tasting_package.id)
    @wine_scorecards = @wines.inject({}) do |list, wine|
      list[wine.id] = Scorecard.where(user: current_guest, event: current_event, wine: wine.id).first
      list
    end
    @guest_scorecards = current_event.guests.includes(:user)
    @host_card = true if params[:host_card] == "show"
  end

  def create
    scorecard = Scorecard.create_scorecard(scorecard_params)
    if params[:trigger_host_card].present?
      redirect_to scores_url(host_card: "show")
    else
      redirect_to scores_url
    end
  end

  private
  def scorecard_params
    params[:scorecard].permit(:wine_id, :rank, :sweetness, :acidity, :finish, :body, :comments).merge({event_id: current_event.id, user_id: current_guest.id})
  end
end