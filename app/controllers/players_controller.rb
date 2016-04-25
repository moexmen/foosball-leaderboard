class PlayersController < ApplicationController
	def index
		active_tab
		@players = Player.where(active: true)
	end

	def show
		active_tab
		@player = Player.find(params[:id])
	end

	def new
		active_tab
		@player = Player.new
	end

	def create
		@player = Player.new(player_params)
		if @player.save
			redirect_to players_path
		else
			puts @player.errors.messages
			active_tab
			render :new
		end
	end

	def edit
		active_tab
		@player = Player.find(params[:id])
	end

	def update
		@player = Player.find(params[:id])

		if @player.update(player_params)
			redirect_to @player
		else
			active_tab
			render :edit
		end
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
