require_relative('../common/CommonlyUsed')
require 'nokogiri'
require 'pry'

module Social
	class YahooAnswerAPI
		include CommonlyUsed
		attr_accessor :list_of_questions

		class YahooAnswer
			attr_accessor :subject, :content, :date, :link, :usernick, :chosenanswer
		end

		class YahooAnswerAPIError < StandardError; end

		def initialize()
			@constYahooURI = "http://answers.yahooapis.com/AnswersService/V1/questionSearch"			
		end

		def askForQuestionsRelatedTo(buzzword)

			@list_of_questions =[]
			request_stub(@constYahooURI,{'appid' => "8erK1DnV34FS7JiqmsmzbgUV1oTeWIoa4fKWXpWMJtnHFU59tPazcqLchgQOFexwnyGedJVDcOVzfeJFaxoL_FD5v6.RS94-", 'query' => buzzword, 'ouput' => 'json'}) do |result|
        
				get_elements_from_XML(result, "//Question") do |q|				
          
					answerHash={}
					q.children.each do |c|
            unless c.name.downcase =="text"				
              answerHash[c.name] = c.text
            end
					end


					@list_of_questions<< answerHash

				end
			end

		rescue Exception => e
			raise YahooAnswerAPIError, "Fehler beim Abfragen der YahooAnswerAPI"
		end
	
	end
end
