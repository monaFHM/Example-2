require_relative '../common/CommonlyUsed'

module Geocoding
	class GoogleGeoAPI
		include CommonlyUsed
		attr_accessor :lat, :lng

		def initialize()
			@GoogleRequestConst="http://maps.googleapis.com/maps/api/geocode/json"
		end


		def askForLngLat(requestParamString)

			if requestParamString.instance_of?(String)

				request_stub(@GoogleRequestConst, {'address' => requestParamString, 'sensor' => 'false'}) do |result|
					location=get_json_from_depth_request(result, ["results", "geometry", "location"])
					each_json_request(location, ["lat"])  {|l| @lat=l}
					each_json_request(location, ["lng"])  {|l| @lng=l}
				end
				
			end
			
		end


	end
end