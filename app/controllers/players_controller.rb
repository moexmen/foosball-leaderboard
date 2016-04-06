class PlayersController < ApplicationController
	def index
		active_tab
		@players = Player.where(active: true)
		@scores = Score.all
	end

	def show
		active_tab
    @profile = Player.get_profile_info(params[:id])
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
	  Player.inactive(@player)

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
