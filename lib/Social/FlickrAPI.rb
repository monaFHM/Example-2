
require_relative('../common/CommonlyUsed')
require 'nokogiri'
require 'pry'

module Social
	class FlickrAPI
		include CommonlyUsed

		attr_accessor :flickr_html_img_tags


		def initialize()
			@Constant="http://api.flickr.com/services/rest/"
			@api_key="1c3e3fb999f90f7a37babaf21d7b3461"
			@api_secret="1da1c7babf372c33"
			@flickr_html_img_tags = []
		end

		def get_pictures_for(buzzword)

			img_tags =[]

			request_stub(@Constant	, {'method' => "flickr.photos.search", 'api_key' => @api_key, 'text' => buzzword,  'per_page' => 20}) do |encoded_result|
				File.open("flickr.xml", 'w') {|f| f.write(encoded_result) }
				each_attribute_from_xpath(encoded_result, "//photo", ["id", "farm", "owner", "secret","server", "title"]) do |a|
					img_tags.push(make_image_tag(a))
				end				
			end


			@flickr_html_img_tags = img_tags
			img_tags
			# File.open("flickrPics.html", 'w') do |f| 

			# 	f.write("<!DOCTYPE html>")
			# 	f.write("<html>")
			# 	f.write("<head></head>")
			# 	f.write("<body>")

			# 	img_tags.each do |img|
			# 		f.write(img) 	
			# 	end

			# 	f.write("</body>")
			# 	f.write("</html>")
				 
			# end

		end


	  def make_image_tag(info_hash)
			info_hash.values.each do |v|
				encodeString(v)
			end	
			return "<img src='http://farm"+info_hash['farm']+".staticflickr.com/"+info_hash['server']+"/"+info_hash['id']+"_"+ info_hash['secret']+"_m.jpg' alt='Flickr Picture' title='"+info_hash['title']+"' />"
		end

	end
end