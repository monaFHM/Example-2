require 'rack'
require 'pry'
require 'cgi'
require 'haml'
load 'lib/BuzzwordSearchApp.rb'
#Start me with rackup config.ru
#config.ru

class HelloWorld



	def initialize()

    #Klassen zur Abfrage der Webservices
    @appClass = BuzzwordSearchApp.new
		
	end

  def call(env)   


    getparam = get_query(env)
          
    if getparam == String.new
      lines=get_html_base(0,0,[],[],[],[])
    	[200,{'Content-Type' => 'text/html'}, lines]	
    else
      #binding.pry
      if !getparam.nil? || !getparam == String.new
        @appClass.query(encode_utf8(getparam))
        lines=get_html_base(@appClass.get_lat, @appClass.get_lng, @appClass.get_current_conditions, @appClass.get_forecast_conditions, @appClass.get_img_tags, @appClass.get_yahoo_questions)
      end

    	[200,{'Content-Type' => 'text/html'}, lines]
    end
    
  end


  def get_query(env)

  	result =""
  	if (env["QUERY_STRING"])
  		getParams= CGI::parse(env["QUERY_STRING"])

  		result = getParams["query"].join
  	end

  	result 
  end




  def get_html_base(lat, lng, curr_c, fore_c, img_tags, yahoo_answers)

    template = File.read('test.haml')
    haml_engine = Haml::Engine.new(template)
    output = haml_engine.render(:locals => {:lat => lat, :lng => lng, :current_conditions => curr_c, :forecast_conditions => fore_c, :flickr_tags => img_tags, :yahoo_items => yahoo_answers}
)
    lines =  output.split(/\n/)
    lines
  end

  def encode_utf8(str)
    str.force_encoding("ISO-8859-1").encode("UTF-8")
  end

  
end

run HelloWorld.new