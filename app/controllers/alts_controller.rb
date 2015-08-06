class AltsController < ApplicationController
	def items
		@member = Alt.find(params[:alt_id])
	    @slot_order_col1 = [16,15,2,3,0,5]
     	@slot_order_col2 = [1,4,7,8,10,11]
	end
end
