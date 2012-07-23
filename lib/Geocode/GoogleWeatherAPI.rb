require_relative '../common/CommonlyUsed'

module Geocoding

	class GoogleWeatherAPI
		include CommonlyUsed

		attr_accessor :current_conditions, :forecast_conditions

		def initialize()
			@URLConst = 'http://www.google.com/ig/api'
			@current_conditions
			@forecast_conditions
		end

		def askForWeather(location)

			request_stub(@URLConst, {'weather' => location, 'hl' => 'DE'}) do |encoded_result|
				@current_conditions=getCurrentConditions(encoded_result)
				@forecast_conditions=getForecastConditions(encoded_result)
			end
		end

		private 
			def getCurrentConditions(xmlString)
				result=[]
				each_attribute_from_subsections(xmlString, '//current_conditions', ["condition","temp_c","humidity","wind_condition"], "data") do |a|
					result.push(a)
				end				
				result
			end

			def getForecastConditions(xmlString)
				result=[]
				each_attribute_from_subsections(xmlString, '//forecast_conditions', ["day_of_week","low","high","condition"], "data") do |a|
					result.push(a)
				end
				result
			end


	end
end
