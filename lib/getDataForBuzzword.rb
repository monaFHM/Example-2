#!/usr/bin/env ruby

#require_relative("*.rb")

require_relative('BuzzwordSearchApp')

@buzzword=""

ARGV.each do|a|
  @buzzword += a
end

puts @buzzword

@queryApp = BuzzwordSearchApp.new
@queryApp.query(@buzzword)


def printer(header, &block)
	puts ""
	puts header.upcase!
	puts "------------------------------------"
	block.call
	puts ""
end


printer("GEO DATA") do
	puts "Lat: " + @queryApp.get_lat
	puts "Lng: " + @queryApp.get_lng
end



printer("WEATHER DATA") do
	puts "Current Conditions "
	p @queryApp.get_current_conditions 
	puts "Forecast "
	p @queryApp.get_forecast_conditions
end



printer("Yahoo Answer Service") do
	p @queryApp.get_yahoo_questions
end

printer ("Flickr")do
 p @queryApp.get_img_tags
end

