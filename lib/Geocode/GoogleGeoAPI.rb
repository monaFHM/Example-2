require_relative '../common/CommonlyUsed'
require 'pry'

module Geocoding
	class GoogleGeoAPI
		include CommonlyUsed
		attr_accessor :lat, :lng


		class GoogleGeoAPIError < StandardError; end

		def initialize()
			@GoogleRequestConst="http://maps.googleapis.com/maps/api/geocode/json"
		end


		def askForLngLat(requestParamString)

			if requestParamString.instance_of?(String)

				request_stub(@GoogleRequestConst, {'address' => requestParamString, 'sensor' => 'false'}) do |result|
					location=get_json_from_depth_request(result, ["results", "geometry", "location"])
					if location ==[]
						raise GoogleGeoAPIError, "Keine geographischen Angaben gefunden"
					else
          	@lat, @lng = location["lat"], location["lng"]
        	end
				end
				
			end
			
		end


	end
end
