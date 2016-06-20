gem 'telegram-bot-ruby'
gem 'json'
require 'telegram/bot'
require 'active_support'
require 'active_support/core_ext'
require 'json'
require 'pp'

#obj = JSON.parse( IO.read("_1.json", encoding:'utf-8') )

metaData = JSON.parse( IO.read("metaData.json", encoding:'utf-8') )

vVP = 		JSON.parse( IO.read("vVP.json", encoding:'utf-8') )
aRFmpb = 	JSON.parse( IO.read("aRFmpb.json", encoding:'utf-8') )
pIA = 		JSON.parse( IO.read("pIA.json", encoding:'utf-8') )
rVPnDNpSRF = JSON.parse( IO.read("rVPnDNpSRF.json", encoding:'utf-8') )
vRPnDNUSA = JSON.parse( IO.read("vRPnDNUSA.json", encoding:'utf-8') )
impTovUslug = JSON.parse( IO.read("impTovUslug.json", encoding:'utf-8') )

token = '188659714:AAHB5aHkp63cp6v6_LQRbaEGXhujhQer1-U'
deb = ""

params = []
param_year = ""
param_district = ""
param_quarter = ""
param_country = ""
param_kind = ""

ord_params = []
ord2_params = []

Telegram::Bot::Client.run(token) do |bot|
	bot.listen do |message|

			s = message.text.mb_chars.downcase!.to_s

			deb << "" << "\n"

			metaData['dataSets'].each do |elem|
				if !s[/#{elem['regEx']}/].nil?
					params << elem['name']
					elem['parameters'].each do |param|
						p "concurrence found"
						p param
						ord_params << param
					end
					break
				else
					p "=== no concurrence"
				end
			end

			p deb

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
					metaData['parameters'].each do |elem|
						if elem['name'] == k
							elem['values'].each { |value|
								if !s[/#{value['regEx']}/].nil?
									o2param[k] = value['value']
									p value['value']
									p s
								end
							}
						end
					end
				}
			}

			p	"----------------------------"
			params << ord2_params

			if vVP['name'] == params[0]

					vVP['data'].each do |elem|
						if elem['year'] == params[1][0]['year']
							deb << params[0] << " " << params[1][0]['year'] << "\n"
							deb << elem['value'].to_s
							deb << " "
							deb << vVP['unit']
							deb << "\n"
						end
					end
				
			elsif

				if aRFmpb['name'] == params[0]
					aRFmpb['data'].each do |elem|
						if elem['year'] == params[1][0]['year']
							deb << params[0] << " " << params[1][0]['year'] << "\n"
       	    	deb << elem['value'].to_s
							deb << " "
							deb << aRFmpb['unit']
            	deb << "\n"
						end
					end
				end

			p deb
			elsif

				if pIA['name'] == params[0]
					pIA['data'].each do |elem|
						if elem['year'] == params[1][0]['year']
							deb << params[0] << " " << params[1][0]['year'] << "\n"
     		    	deb << elem['value'].to_s
							deb << " "
							deb << pIA['unit']
     	      	deb << "\n"
						end
					end
				end

			elsif

				if rVPnDNpSRF['name'] == params[0]
					rVPnDNpSRF['data'].each do |elem|
						if ((elem['year'] == params[1][0]['year']) && (elem['district']) == params[1][1]['district'])
							deb << params[0] << " " << params[1][0]['year'] << "/" << params[1][1]['district'] << "\n"
              deb << elem['kind'].to_s
              deb << "\n"
              deb << elem['value'].to_s
              deb << " "
              deb << rVPnDNpSRF['unit']
              deb << "\n"
						end
			  	end					
				end

			elsif

				if vRPnDNUSA['name'] == params[0]
					vRPnDNUSA['data'].each do |elem|
            if ((elem['year'] == params[1][0]['year']) && (elem['country']) == params[1][1]['country'])
              deb << params[0] << " " << params[1][0]['year'] << "/" << params[1][1]['country'] << "\n"
              deb << elem['kind'].to_s
              deb << "\n"
              deb << elem['value'].to_s
              deb << " "
              deb << vRPnDNUSA['unit']
              deb << "\n"
            end
          end
				end

			elsif

				if impTovUslug['name'] == params[0]
					impTovUslug['data'].each do |elem|
						if ((elem['year'] == params[1][0]['year']) && (elem['quarter'] == params[1][1]['quarter']))
							deb << params[0] << " " << params[1][0]['year'] << "/" << params[1][1]['quarter'] << "\n"
							deb << elem['kind'].to_s
							deb << "\n"
							deb << elem['value'].to_s
							deb << " "
							deb << impTovUslug['unit']
							deb << "\n"
						end
					end
				end

			else
				deb << "#{metaData['noData']}"
				p "some problem with this data. I DONT UNDERSTAND YOU, BABY"
			end

			deb << "#{metaData['noData']}" if deb.length < 10
			p params
			p deb
			bot.api.send_message(chat_id: message.chat.id, text: deb)
			deb.clear
			ord2_params.clear
			params.clear

	end
end
