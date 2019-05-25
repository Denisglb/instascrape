require 'open-uri'
require 'HTTParty'
require 'mechanize'
require 'json'
require 'date'

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
  		numberOfPosts
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

	def numberOfPosts
		@data << @description.strip.split(', ')[2].split('-')[0]
	end

	def content
		# NEED TO PARSE DATA PROPERLY HERE

		info = @page.body.split("<script type=\"text/javascript\">window._sharedData = ")[1]
		json = info.split(";</script>\n<script type=\"text/javascript\">window.__initialDataLoaded(window._sharedData);")[0].delete! '\\'

		parsed_data = JSON.parse(json)
		puts "Biography"
		p parsed_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]["biography"]

		puts "Followers"
		p parsed_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_followed_by"]

		puts "Following"
		p parsed_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_follow"]

		puts "Is a Business Account"
		p parsed_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]["is_business_account"]

		puts "Business Category name"
		p parsed_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]["business_category_name"]

		puts "User name"
		p parsed_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]["username"]

		puts "Number of Posts"
		p parsed_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_owner_to_timeline_media"]["count"]

		puts "Page Info"
		p parsed_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_owner_to_timeline_media"]["page_info"]

		puts "Information from posts"
		posts = parsed_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"][0]
		
		p "Captions of Post -> " + posts["node"]["edge_media_to_caption"]["edges"][0]["node"]["text"].to_s
		p "Number of comments for Post -> " + posts["node"]["edge_media_to_comment"]["count"].to_s
		p "Time Posted -> " + Time.at(posts["node"]["taken_at_timestamp"]).to_datetime.to_s
		p "Number of likes of the post -> " + posts["node"]["edge_liked_by"]["count"].to_s
		p "Location Tags -> " + posts["node"]["location"].to_s
		p "Owner of the post -> " + posts["node"]["owner"].to_s
		p "Is it a Video -> " + posts["node"]["is_video"].to_s
		p "Video Views -> " + posts["node"]["video_view_count"].to_s


	end

end

scraper = Scraper.new
scraper.get_user_information("dogsofinstagram")


