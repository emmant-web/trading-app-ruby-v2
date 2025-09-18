require 'uri'
require 'net/http'

class AlphaApi

	def self.get_stock_price(symbol)
		url = URI("https://alpha-vantage.p.rapidapi.com/query?function=TIME_SERIES_DAILY&symbol=#{symbol}&outputsize=compact&datatype=json")

		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true

		request = Net::HTTP::Get.new(url)
		request["x-rapidapi-key"] = ENV.fetch("API_KEY", nil)
		request["x-rapidapi-host"] = 'alpha-vantage.p.rapidapi.com'

		response = http.request(request)
		JSON.parse(response.body)
	end

	def self.get_company_name(symbol)
    url = URI("https://alpha-vantage.p.rapidapi.com/query?function=OVERVIEW&symbol=#{symbol}")
    
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = ENV.fetch("RAPIDAPI_KEY", nil)
    request["x-rapidapi-host"] = 'alpha-vantage.p.rapidapi.com' 

    response = http.request(request)
    data = JSON.parse(response.body)

    data["Name"] || symbol.upcase # fallback to symbol
  rescue => e
    puts "API error for #{symbol}: #{e.message}"
    symbol.upcase
  end
end








