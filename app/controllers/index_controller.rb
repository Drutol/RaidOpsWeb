class IndexController < ApplicationController
	skip_before_filter :require_login
	before_filter do
	     if request.host != "www.raidops.tk" && Rails.env.production? then redirect_to "http://raidops.tk" end
	     if request.ssl? && Rails.env.production?
	      redirect_to :protocol => 'http://', :status => :moved_permanently
	    end
  	end
	def welcome

	end

	def search
		members = GuildMember.where('name LIKE ? AND guild_id IS NOT NULL', "%#{params[:search]}%")
		ids = Array.new
		for member in members do
			if Guild.where('id = ?',member.guild_id).count > 0 then
				ids.push(member.id)
			end
		end
		@search_grid = initialize_grid(GuildMember.where(id: ids))
	end

end
