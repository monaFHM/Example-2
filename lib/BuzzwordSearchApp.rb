require_relative('Geocode/GoogleGeoAPI.rb')
require_relative('Geocode/GoogleWeatherAPI.rb')
require_relative('Social/YahooAnswerAPI.rb')
require_relative('Social/FlickrAPI.rb')
require 'pry'

class BuzzwordSearchApp
	attr_reader :error

	class BuzzwordSearchError < StandardError
			attr_reader :api_error

			def initialize(childerror)
				@api_error=childerror
			end
	end
	
	def initialize()
		@googleGeo = Geocoding::GoogleGeoAPI.new
		@googleWeater = Geocoding::GoogleWeatherAPI.new
		@yahooAnswer =Social::YahooAnswerAPI.new
		@flickr = Social::FlickrAPI.new

		@error=false
	end

	def query(buzzword)
			@googleGeo.askForLngLat(buzzword)
			@googleWeater.askForWeather(buzzword)
			@yahooAnswer.askForQuestionsRelatedTo(buzzword)
			@flickr.get_pictures_for(buzzword)
			@error=false
	rescue Geocoding::GoogleGeoAPI::GoogleGeoAPIError, Geocoding::GoogleWeatherAPI::GoogleWeatherAPIError, Social::FlickrAPI::FlickrAPIError, Social::YahooAnswerAPI::YahooAnswerAPIError => apierror
		@error=true		
		#raise BuzzwordSearchError.new(apierror), "Fehler beim Abfragen der APIs"
	end


	def get_lng()
		@googleGeo.lng.to_s
	end

	def get_lat()
		@googleGeo.lat.to_s
	end

	def get_current_conditions()
		@googleWeater.current_conditions
	end

	def get_forecast_conditions()
		@googleWeater.forecast_conditions
	end

	def get_yahoo_questions()
		@yahooAnswer.list_of_questions
	end

	def get_img_tags()
		@flickr.flickr_html_img_tags
	end
end
