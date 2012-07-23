require_relative('../common/CommonlyUsed')
require 'nokogiri'
require 'pry'

module Social
	class YahooAnswerAPI
		include CommonlyUsed
		attr_accessor :list_of_questions

		class YahooAnswer
			attr_accessor :subject, :content, :date, :link, :usernick, :chosenanswer

			def initialize()
				@subject =""
				@content =""
				@date =""
				@link =""
				@usernick=""
				@chosenanswer=""
			end
		end

		def initialize()
			@constYahooURI = "http://answers.yahooapis.com/AnswersService/V1/questionSearch"
			@list_of_questions=[]
		end

		def askForQuestionsRealtedTo(buzzword)
			request_stub(@constYahooURI,{'appid' => "8erK1DnV34FS7JiqmsmzbgUV1oTeWIoa4fKWXpWMJtnHFU59tPazcqLchgQOFexwnyGedJVDcOVzfeJFaxoL_FD5v6.RS94-", 'query' => buzzword, 'ouput' => 'json'}) do |result|
				File.open("yahooanwers.xml", 'w') {|f| f.write(result) }
				get_elements_from_XML(result, "//Question") do |q|				
					answer = YahooAnswer.new
					answerHash={}
					q.children.each do |c|
							unless c.name.downcase! =="text"				
								answerHash[c.name] = get_text_from_node(c)
							end
					end

					@list_of_questions.push(answerHash)

				end
			end

			#p @list_of_questions
		end
	
	end
end
