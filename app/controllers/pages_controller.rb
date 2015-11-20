class PagesController < ApplicationController
	def index
		@competitions = Competition.latest
		@tags = ActsAsTaggableOn::Tag.most_used
	end
end
