gem 'telegram-bot-ruby'
gem 'json'
require 'telegram/bot'
require 'active_support'
require 'active_support/core_ext'
require 'json'
require 'pp'

obj = JSON.parse( IO.read("_1.json", encoding:'utf-8') )
impTovUslug = JSON.parse( IO.read("impTovUslug.json", encoding:'utf-8') )
vVP = JSON.parse( IO.read("vVP.json", encoding:'utf-8') )
pIA = JSON.parse( IO.read("pIA.json", encoding:'utf-8') )
aRFmpb = JSON.parse( IO.read("aRFmpb.json", encoding:'utf-8') )

token = '188659714:AAHB5aHkp63cp6v6_LQRbaEGXhujhQer1-U'
deb = "DEBUG START\n"

params = []
ord_params = []
ord2_params = []

Telegram::Bot::Client.run(token) do |bot|
	bot.listen do |message|
		
	  #case message.text
		s = message.text.mb_chars.downcase!.to_s

		deb << "source:\n"
		deb << s << "\n\n"

		obj['dataSets'].each do |elem|
			if !s[/#{elem['regEx']}/].nil?
				params << elem['name']
				elem['parameters'].each do |param|
					p "concurrence found"
					ord_params << param
				end
			else
				p "=== no concurrence"
			end
		end

		ord_params.each do |oparam|
			h = Hash.new
			h["#{oparam['name']}"] = oparam['default']
			ord2_params << h
		end
		p ord2_params
		ord_params.clear
		p params
		p	"----------------------------"

		ord2_params.map { |o2param|
			o2param.map { |k, v|
				obj['parameters'].each do |elem|
					if elem['name'] == k
						elem['values'].each { |value|
							if !s[/#{value['regEx']}/].nil?
								o2param[k] = value['value']
							end
						}
					end
				end
			}
		}

		#ord2_params.map do |o2param|
		#	p o2param
		#	o2param.map { |k, v|
		#		obj['parameters'].each do |elem|
		#			if elem['name'] == k
		#				elem['values'].each { |value|
		#					p "=_+_+_+_+_+_="
		#					p value['regEx']
		#					p !s[/#{value['regEx']}/].nil?
		#					if !s[/#{value['regEx']}/].nil?
		#						p "=====+"
		#						p v
		#						p value['value']
		#						v = value['value']
		#						p v
		#						p "=====+"
		#					end
		#				}
		#			end
		#		end
		#		#p k
		#		#p v
		#	}
		#	p o2param
		#end

		p ord2_params

		p	"----------------------------"
		params << ord2_params

		if impTovUslug['name'] == params[0]
			impTovUslug['data'].each do |elem|
				if ((elem['year'] == params[1][0]['year']) && (elem['quarter'] == params[1][1]['quarter']))
					deb << elem['kind'].to_s
					deb << "\n"
					deb << elem['value'].to_s
					deb << "\n"
				end
			end
		elsif
			if vVP['name'] == params[0]
				vVP['data'].each do |elem|
					if elem['year'] == params[1][0]['year']
						deb << elem['value'].to_s
						deb << "\n"
					end
				end
			end
		elsif
			if pIA['name'] == params[0]
				pIA['data'].each do |elem|
					if elem['year'] == params[1][0]['year']
            deb << elem['value'].to_s
            deb << "\n"
					end
				end
			end
		elsif
			if aRFmpb['name'] == params[0]
				aRFmpb['data'].each do |elem|
					if elem['year'] == params[1][0]['year']
            deb << elem['value'].to_s
            deb << "\n"
					end
				end
			end
		end

		deb << "\nDEBUG END"

		p params
		bot.api.send_message(chat_id: message.chat.id, text: deb)
		deb.clear
		ord2_params.clear
		params.clear
		#when 'A'
		#	bot.api.send_message(chat_id: message.chat.id, text: "You are pushed buttom A")
		#when 'B'
		#	bot.api.send_message(chat_id: message.chat.id, text: "You are pushed buttom B")
		#when 'C'
		#	bot.api.send_message(chat_id: message.chat.id, text: "You are pushed buttom C")
		#when 'D'
		#	bot.api.send_message(chat_id: message.chat.id, text: "You are pushed buttom D")
  	#when '/start'
    #	question = 'yes, everything all right! may be one of these variants you interesting'
    #	answers =
    #  	Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [%w(A B), %w(C D)], one_time_keyboard: true)

    #	bot.api.send_message(chat_id: message.chat.id, text: question, reply_markup: answers)
  	#when '/stop'
    #	kb = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)

    #	bot.api.send_message(chat_id: message.chat.id, text: 'Sorry to see you go :(', reply_markup: kb)
  	#end
	end
end
