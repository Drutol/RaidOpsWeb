class IndexController < ApplicationController
	skip_before_filter :require_login
	def welcome

	end
end
