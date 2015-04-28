class LogsController < ApplicationController
 	def show

  	end

  	def create
	    @guild = Guild.find(params[:guild_id])
  		for member in @guild.guild_members do
  			if member.id.to_f == params[:guild_member_id].to_f then
  				member.logs.create(log_params)
  				break
  			end 
  		end
	    redirect_to guild_path(@guild)
	end
 
  private
    def log_params
      params.require(:log).permit(:strComment, :strType ,:strModifier, :strTimestamp)
    end
end
