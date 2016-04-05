require 'json'

class PlayersController < ApplicationController
	def index
		active_tab
		@players = Player.all
		@scores = Score.all
	end

	def show
		active_tab
		@player = Player.find(params[:id])
    profile_details = Player.get_profile_json(params[:id])
    json_dict = JSON.parse(profile_details)

    @score_details = JSON.parse(json_dict['score_details'])
    @match_details = JSON.parse(json_dict['match_details'])
  end

  def format(hash)
    output = Hash.new
    hash.each do |key, value|
      output[key] = cleanup(value)
    end
    output
  end

	def new
		active_tab
		@player = Player.new
	end

	def create
		@player = Player.new(player_params)
		@player.save

		redirect_to players_path
	end

	def edit
		active_tab
	  @player = Player.find(params[:id])
	end

	def update
		@player = Player.find(params[:id])

	  @player.update(player_params)
	  redirect_to @player
	end

	def destroy
	  @player = Player.find(params[:id])
	  @player.destroy

	  redirect_to players_path
	end

	def active_tab
		@active = 1
	end

private
	def player_params
		params.require(:player).permit(:name, :alias)
	end
end
