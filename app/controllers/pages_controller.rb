class PagesController < ApplicationController
	def index
		@competitions = Competition.latest
	end
end
