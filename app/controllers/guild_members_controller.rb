class GuildMembersController < ApplicationController
	def create
	    @guild = Guild.find(params[:guild_id])
	    @guild_member = @guild.guild_members.create(member_params)
	    redirect_to guild_path(@guild)
	end
 
  private
    def member_params
      params.require(:guild_member).permit(:name, :ep ,:gp, :str_class,:str_role,:net,:tot)
    end
end
