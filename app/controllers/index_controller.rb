class IndexController < ApplicationController
	skip_before_filter :require_login
	require 'open-uri'
	def welcome
		@hash = JSON.load(open('http://tooltipz.com/en/api/item/40093'))
		ItemDatum.new(	:item_id => @hash[:id],
						:name => @hash[:name],
						:category => @hash[:category],
						:type => @hash[:category],
						:slot => @hash[:slot])
		@record = initialize_grid(ItemDatum)
	end
end
