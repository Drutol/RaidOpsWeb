class GuildMembersController < ApplicationController
	def create
	    @guild = Guild.find(params[:guild_id])
	    @guild_member = @guild.guild_members.create(member_params)
	    redirect_to guild_path(@guild)
	end

	def edit
		@member = GuildMember.find(params[:id])
	end

	def change

		guild = Guild.find(params[:guild_id])
		member = guild.guild_members.find(params[:id])
		edit_member = GuildMember.find_by_edit_flag(params[:id])
		if not edit_member then
			guild.guild_members.create!(:name => member_params[:name],:ep => member_params[:ep],:gp => member_params[:gp],:pr => "%.2f"%(member_params[:ep].to_f/member_params[:gp].to_f),:str_class => member_params[:str_class],:str_role => member_params[:str_role],:tot => member.tot,:net => member.net,:edit_flag => params[:id]) #TODO DKP
		else
			edit_member.update!(:name => params[:name],:ep => params[:ep],:gp => params[:gp],:pr => "%.2f"%(params[:ep].to_f/params[:gp].to_f),:str_class => params[:str_class],:str_role => params[:str_role],:tot => member.tot,:net => member.net,:edit_flag => params[:id]) #TODO DKP
		end
		redirect_to guild_path(guild)
	end
 
  private
    def member_params
      params.require(:guild_member).permit(:name, :ep ,:gp, :str_class,:str_role,:net,:tot)
    end
end
