require 'rack'
require 'pry'
require 'haml'
require 'tilt' 
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
          
    if getparam.nil? ||getparam == String.new
      lines=get_html_base(nil,"")
    	[200,{'Content-Type' => 'text/html'}, lines]	
    else
        @appClass.query(getparam)    
        lines=get_html_base(@appClass, getparam)
      	[200,{'Content-Type' => 'text/html'}, lines]
    end
    
  end


  def get_query(env)

  	result =""
  	if (env["QUERY_STRING"])
  		paramstr= env["QUERY_STRING"]
      unescaped=Rack::Utils.unescape(paramstr)
      getParams=Rack::Utils.parse_query(unescaped)
  		result = getParams["query"]
  	end

  	result 
  end




  def get_html_base(appClass, getparam)

#     template = File.read('test.haml')
#     haml_engine = Haml::Engine.new(template)
#     output = haml_engine.render(:locals => {:lat => lat, :lng => lng, :current_conditions => curr_c, :forecast_conditions => fore_c, :flickr_tags => img_tags, :yahoo_items => yahoo_answers}
# )
    if !appClass || appClass.error
      lat = 0
      lng = 0
      curr_c=[]
      fore_c=[]
      img_tags=[]
      yahoo_answers=[]
      query=""
      if !appClass
        error=false
      else
        error=true
      end
    else
      lat = appClass.get_lat
      lng = appClass.get_lng
      curr_c=appClass.get_current_conditions
      fore_c=appClass.get_forecast_conditions
      img_tags=appClass.get_img_tags
      yahoo_answers=appClass.get_yahoo_questions
      query=getparam
      error=appClass.error
   end

    context = Object.new  
    def context.title  
        "Buzzword Search App"  
    end  
      
    template = Tilt::HamlTemplate.new("test.haml")  
    output=template.render(context, :locals => {:lat => lat, :lng => lng, :current_conditions => curr_c, :forecast_conditions => fore_c, :flickr_tags => img_tags, :yahoo_items => yahoo_answers, :query => query, :error=> error})  

    lines =  output.split(/\n/)
  end

  def encode_utf8(str)
    str.force_encoding("ISO-8859-1").encode("UTF-8")
  end

  
end

run HelloWorld.new