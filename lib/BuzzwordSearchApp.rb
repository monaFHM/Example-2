require_relative('Geocode/GoogleGeoAPI.rb')
require_relative('Geocode/GoogleWeatherAPI.rb')
require_relative('Social/YahooAnswerAPI.rb')
require_relative('Social/FlickrAPI.rb')

class BuzzwordSearchApp

	def initialize()
		@googleGeo = Geocoding::GoogleGeoAPI.new
		@googleWeater = Geocoding::GoogleWeatherAPI.new
		@yahooAnswer =Social::YahooAnswerAPI.new
		@flickr = Social::FlickrAPI.new
	end

	def query(buzzword)
		@googleGeo.askForLngLat(buzzword)
		@googleWeater.askForWeather(buzzword)
		@yahooAnswer.askForQuestionsRealtedTo(buzzword)
		@flickr.get_pictures_for(buzzword)
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