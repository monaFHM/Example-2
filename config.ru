require 'rack'
require 'pry'
require 'cgi'
require 'haml'
load 'lib/BuzzwordSearchApp.rb'
#Start me with rackup config.ru
#config.ru

class HelloWorld

	def initialize()
		#HTML 
		@htmlbase=[]

    @appClass = BuzzwordSearchApp.new

		#HTML Konstanten fuer Default ( keine Query )
		@GoogleMapConst = '<iframe width="300" height="200" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="https://maps.google.de/?ie=UTF8&amp;ll=51.151786,10.415039&amp;spn=11.062731,33.815918&amp;t=m&amp;z=6&amp;output=embed"></iframe>'
		@GoogleGeoConst = '<p></p>'
		@YahooConst= '<p></p>'
		@FlickrConst = '<p></p>'

		#inital keine Query, Variablen für spezifische Inhalte
		@google_map_html, @google_geo_html, @yahoo_html, @flickr_html = @GoogleMapConst, @GoogleGeoConst, @YahooConst, @FlickrConst

		#Klassen zur Abfrage von Webservice
		
	end

  def call(env)   


    getParam = getQuery(env)
    #binding.pry
    lines = getHTMLBase()

    #Look for lines to replace
    
    flickr_nr = lines.index(lines.grep(/\s+FLICKR/)[0])
    geo_nr = lines.index(lines.grep(/\s+GOOGLEGEO/)[0])
    weather_nr = lines.index(lines.grep(/\s+GOOGLEWEATHER/)[0])
    yahoo_nr = lines.index(lines.grep(/\s+YAHOO/)[0])
    
    if getParam == String.new
      lines[flickr_nr]=@FlickrConst
      lines[geo_nr]=@GoogleGeoConst 
      lines[weather_nr]=@GoogleMapConst
      lines[yahoo_nr]=@YahooConst

    	[200,{'Content-Type' => 'text/html'}, lines]	
    else
      #binding.pry
      unless getParam.nil? || getParam == String.new
        @appClass.query(getParam.force_encoding("ISO-8859-1").encode("UTF-8"))
        lines[flickr_nr]=@appClass.get_img_tags[0..30].join
      end

    	[200,{'Content-Type' => 'text/html'}, lines]
    end
    
  end


  def getQuery(env)

  	result =""
  	if (env["QUERY_STRING"])
  		getParams= CGI::parse(env["QUERY_STRING"])

  		result = getParams["query"][0]
  	end

  	result 
  end




  def getHTMLBase
  	@htmlbase=[]

    template = File.read('test.haml')
    haml_engine = Haml::Engine.new(template)
    output = haml_engine.render
    lines =  output.split(/\n/)

  	# f = File.open("test.html", "r") 
  	# f.each_line do |line|
  	# 	@htmlbase << line
  	# end
  	# @htmlbase
    lines
  end


end

run HelloWorld.new