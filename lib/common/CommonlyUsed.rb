
require 'json'
require 'net/http'
require 'uri'
require 'nokogiri'
require 'pry'

module CommonlyUsed


	def each_json_request(json_obj, request_params)
	
		unless request_params.nil? || json_obj.nil?

			unless json_obj.instance_of?(Hash)
				json_array = JSON::parse(json_obj)			
			else
				json_array=json_obj
			end

			request_params.each do |r|
				value= json_array[r]	
				yield value unless value.nil?				
			end
		end

	#rescue JSON::ParserError => e
	#	p e
	end

	def get_json_from_depth_request(json_obj, depth_request)
		
		unless json_obj.nil? || depth_request.nil?
			json_obj=JSON::parse(json_obj)

			depth_request.each do |item|
				if json_obj.instance_of?(Hash)
					json_obj = json_obj[item] if json_obj[item]
				elsif json_obj.instance_of?(Array)
					json_obj.each do |hashitem|
						json_obj=hashitem[item] if hashitem[item]
					end
				end

			end
		end

		json_obj
	end

	def get_elements_from_XML(xmlString, xpath)
		doc = Nokogiri::XML(xmlString)
		
		doc.remove_namespaces!		
		doc.xpath(xpath).each do |node|
  			yield node
		end
	end

	def each_attribute_from_child_node_XML(xmlitem, xPatharray, attr_name)
		if xmlitem.instance_of?(String)
		 	doc = Nokogiri::XML(xmlitem)
		 else
			doc =xmlitem
		end

		result= Array.new

		unless xPatharray.nil?
			xPatharray.each do |item|
				doc.xpath(item+"[@#{attr_name}]").each do |attrElement|
					#binding.pry
					result.push(attrElement[attr_name])
				end
			end
		end

		result
	end

	def each_attribute_from_node_XML(xmlitem, attr_names)
		if xmlitem.instance_of?(String)
		 	doc = Nokogiri::XML(xmlitem)
		 else
			doc =xmlitem
		end

		result= Hash.new

		unless doc.nil?
			attr_names.each do |item|
				result[item] = doc.attr(item)
			end
		end
		result
	end

	# def set_value_via_reflection(obj, prop, value)
	# 	obj.send(prop+"=", value)
	# end

	def each_attribute_from_xpath(xmlString, element_name, attr_names)
		get_elements_from_XML(xmlString, element_name) do |item|
			yield each_attribute_from_node_XML(item, attr_names)
		end
	end

	def each_attribute_from_subsections(xmlString, subsection_xpath, xpathattrelements, attr_name) 

		get_elements_from_XML(xmlString, subsection_xpath) do |subsection|
			#binding.pry
			yield each_attribute_from_child_node_XML(subsection, xpathattrelements, attr_name)
		end
	end

	def get_text_from_node(node)
		return node.text
	end

	def encodeString(str)
		str.force_encoding("ISO-8859-1").encode("UTF-8")
	end

	def request_Webservice(requestString)
		unless requestString.empty? 
			begin
				url = URI.escape(requestString)
				resp = Net::HTTP.get_response(URI.parse(url))
			rescue Exception
				puts Exception
				nil
			end
		end 
	end

	def make_Uri_String_from_Hash(hash)
		first =true
		#outputString=String.new
		outputString=""

		unless hash.nil?
			hash.each do |key,value|
				outputString +="&" unless first 
				outputString +="?" if first
				outputString +=key.to_s
				outputString +="="
				value=value.to_s
				value=value.split(/  */).join('+')
				outputString +=value

				first=false if first
			end	
	 	end
	 	#binding.pry
		outputString
	end


	def request_stub(const, paramsHash)
			result=nil
			requestURL = const + make_Uri_String_from_Hash(paramsHash)
			webserviceResponse=request_Webservice(requestURL)
			
			if webserviceResponse.code == "200"				
				encoded_result=encodeString(webserviceResponse.body)
				result = encoded_result
				result= yield encoded_result if block_given?
			else
				raise "Webservice Request unsuccesfully: " + webserviceResponse.body 
			end
			
			result
	end
	
end