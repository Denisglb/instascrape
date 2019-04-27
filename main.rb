require 'open-uri'
require 'HTTParty'
require 'mechanize'
require 'json'

class Scraper
	include HTTParty
	
	attr_reader :description, :page
	base_uri 'https://www.instagram.com/'

	def initialize
		@data = []
		@page = page
		@description = description
  	end

  	def get_user_information(user)
  		@page = Mechanize.new.get("https://www.instagram.com/" + user)
  		@description = @page.at_css('meta[property="og:description"]')['content']
  		@data << user
  		followers
  		following
  		handle
  		posts
  		content
	end 

	def followers
 		@data << @description.strip.split(', ')[0]
	end

	def following
		@data << @description.strip.split(', ')[1]
	end

	def handle
		@data << "@" + @description.strip.split(', ')[2].split('@')[-1].chomp(')')
	end

	def posts
		@data << @description.strip.split(', ')[2].split('-')[0]
	end

	def content
		# NEED TO PARSE DATA PROPERLY HERE
		p @page.body
		content = @page.body.split('window.__initialDataLoaded(window._sharedData)')[0]
		json = content.split('<script type="text/javascript">window._sharedData =')[1]
		p json
		# p json.class
		# more = json.split(';</script>\n<script type=\"text/javascript\">window.__initialDataLoaded(window._sharedData);')[0]
		# more.split(';</script>\n<script type=\"text/javascript\">window.__initialDataLoaded(window._sharedData);')[0]
		# p more
		# parsed_data = JSON.parse(json)
		# p parsed_data
	end

end

scraper = Scraper.new
scraper.get_user_information("dogsofinstagram")


