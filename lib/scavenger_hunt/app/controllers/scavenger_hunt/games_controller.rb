class ScavengerHunt::GamesController < ScavengerHunt::ApplicationController

  before_action :find_game, except: %w(new)

  def finish
    if params[:confirm]
      @game.touch(:ended_at)
      redirect_to player_path
    end
  end

  def new
    location = ScavengerHunt::Location.find(params[:location_id])
    player = current_player || create_player!
    game = player.games.active.find_or_create_by!(location: location)
    redirect_to game_path(game)
  end

  def show
  end

  private

  def create_player!
    ScavengerHunt::Player.create!(ip: request.ip, user_agent: request.user_agent).tap do |player|
      cookies[current_player_key] = player.id
    end
  end
end