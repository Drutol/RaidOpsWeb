class IndexController < ApplicationController
	skip_before_filter :require_login
	before_filter do
	     if request.host != "www.raidops.net" && Rails.env.production? then redirect_to "http://raidops.net" end
	     if request.ssl? && Rails.env.production?
	      redirect_to :protocol => 'http://', :status => :moved_permanently
	    end
  	end
	def welcome

	end

end
