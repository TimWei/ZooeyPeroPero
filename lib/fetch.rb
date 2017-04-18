require 'openssl'
require 'json'
require 'open-uri'
require 'nokogiri'

class Fetch
	WIKI_URL = 'http://gbf-wiki.com/index.php?%C4%CC%BE%EF%A5%DE%A5%EB%A5%C1%A5%D0%A5%C8%A5%EB%CA%E7%BD%B8%C8%C4%2F%B5%DF%B1%E7ID%CA%E7%BD%B8'
	TARS = ['黒麒麟','グランデ', 'バハ','よわばは','よわバハ','団グランデ','ランデ']

	def initialize
		@buffer ||= []
		config_file =  File.read 'lib/config.json', external_encoding: 'utf-8'
		config = JSON.parse config_file

		@wiki_url = config['wiki_url']
		@tars = config['targets']

		get_data.each{|t| @buffer << t}
		Encoding.default_external = 'utf-8'
	end

	def new_rows
		data = get_data
		new_rows = check_data data
		new_rows
	end

	private
	def get_data
		doc = Nokogiri::HTML(open(@wiki_url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
		rows = doc.xpath("//li[@class='pcmt']")
		result = []
		rows.each do |row|
			data = row.text.sub('　',' ').split(' ')
			data_name = data[0]
			data_id = data[1]
			data_timestamp = data[-2]
			result << [data_name,data_id,data_timestamp] if @tars.include?(data_name)
		end
		return result
	end

	def check_data data
		new_data = data - @buffer
		new_data.each{|t| @buffer << t}
		clear_buffer if @buffer.size > 100
		new_data.empty? ? nil : new_data
	end

	def clear_buffer
		@buffer = @buffer[80..99]
	end
end