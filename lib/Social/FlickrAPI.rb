
require_relative('../common/CommonlyUsed')
require 'nokogiri'
require 'pry'

module Social
	class FlickrAPI
		include CommonlyUsed

		attr_accessor :flickr_html_img_tags

		class FlickrAPIError < StandardError; end
			

		def initialize()
      #@Constant should be a constant
			@Constant="http://api.flickr.com/services/rest/"
			@api_key="1c3e3fb999f90f7a37babaf21d7b3461"
			@api_secret="1da1c7babf372c33"
		end

		def get_pictures_for(buzzword)

			img_tags =[]

			request_stub(@Constant	, {'method' => "flickr.photos.search", 'api_key' => @api_key, 'text' => buzzword, 'per_page' => '20'}) do |encoded_result|
				each_attribute_from_xpath(encoded_result, "//photo", ["id", "farm", "owner", "secret","server", "title"]) do |a|
					img_tags << make_image_tag(a)
				end				
			end


			@flickr_html_img_tags = img_tags			
		rescue Exception =>e
			raise FlickrAPIError, "keine Bilder zur Anfrage gefunden"
		end



		def make_image_tag(info_hash)			
			"<img src='http://farm"+info_hash['farm']+".staticflickr.com/"+info_hash['server']+"/"+info_hash['id']+"_"+ info_hash['secret']+"_m.jpg' alt='Flickr Picture' title='"+info_hash['title']+"' />"
		end

	end
end
