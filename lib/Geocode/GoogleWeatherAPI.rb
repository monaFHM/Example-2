require_relative '../common/CommonlyUsed'
require 'pry'

module Geocoding

	class GoogleWeatherAPI
		include CommonlyUsed

		attr_accessor :current_conditions, :forecast_conditions

		class GoogleWeatherAPIError < StandardError; end


		URLCONST = 'http://www.google.com/ig/api'

		def initialize()      
		end

		def askForWeather(location)

			request_stub(URLCONST, {'weather' => location, 'hl' => 'DE'}) do |encoded_result|
				@current_conditions=getCurrentConditions(encoded_result)
				@forecast_conditions=getForecastConditions(encoded_result)

				if @current_conditions == [] && @forecast_conditions == []
					raise GoogleWeatherAPIError, "Keine Wetterdaten fuer Angabe gefunden"
				end
			end
		end

		private 
			def getCurrentConditions(xmlString)
				result=[]
				each_attribute_from_subsections(xmlString, '//current_conditions', ["condition","temp_c","humidity","wind_condition"], "data") do |a|
					result << a
				end				
				result
			end

			def getForecastConditions(xmlString)
				result=[]
				each_attribute_from_subsections(xmlString, '//forecast_conditions', ["day_of_week","low","high","condition"], "data") do |a|
					result << a
				end
				#binding.pry
				result
			end


	end
end
