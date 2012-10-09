# encoding: UTF-8
'''
Parser for extract the seaports information 
that has container service deliver from:
http://www.worldportsource.com/
'''
require 'nokogiri'
require 'open-uri'
require 'mechanize'
require './Port'

class WP_XParser
	ROOT_URL = 'http://www.worldportsource.com'
	COUNTRIES_FILE = '/countries.php'
	SHIPPING_URL = '/shipping/country/ports'
	SCRIPT_EXTENSION = '.php'

	def initialize
		mechanize = Mechanize.new
		@@WORLDPORTSOURCE = mechanize.get( ROOT_URL + COUNTRIES_FILE )
	end

	def get_worldportsource() return @@WORLDPORTSOURCE end

	def extract_country_codes
		links = @@WORLDPORTSOURCE.links.find_all do |link|
			/\/ports\/index\/[\w]+.php/ =~ link.href
		end

		country_codes = []
		links.each do |link|
			m = /(\w+)(.php)/.match(link.href)	
			country_codes << m[1]
		end

		return country_codes
	end

	def get_port_links country_code
		'''
		Givin country_code eg. PER , returns an array of
		links of the seaports.
		'''
		country_url = '/' + country_code + SCRIPT_EXTENSION

		mechanize = Mechanize.new
		mechanize = mechanize.get(ROOT_URL + SHIPPING_URL + country_url)

		ports_links = mechanize.links.find_all do |link|
			/\/ports\/\w+_\w+.php/ =~ link.href
		end

		return ports_links
	end

	def get_port_information port
		url = ROOT_URL + port.href
		doc = Nokogiri::HTML( open(url) )
		if doc.at_css('.form:nth-child(4)').to_s.scan(/Local Port Name/).size > 0
			### Some ports html doc has attribute Local Port Name
			### removes th, local port name, to fix unclosed table row tags.
			nodeset = doc.xpath('//th[contains(text(), "Local Port Name")]').first
			nodeset.next_element.remove
			nodeset.next_element.remove
			nodeset.remove
		end
		port_location 	= doc.at_css('tr:nth-child(2) :nth-child(3)').text
		port_name 			= doc.at_css('tr:nth-child(3) b').text
		port_authority 	= doc.at_css('tr:nth-child(4) :nth-child(3)').text
		address 				= doc.at_css('tr:nth-child(5) :nth-child(3)').inner_html.gsub(/<br>/, ' ')
		phone 					= doc.at_css('tr:nth-child(6) :nth-child(3)').text
		fax 						= doc.at_css('tr:nth-child(7) :nth-child(3)').text
		eight_number 		= doc.at_css('tr:nth-child(8) :nth-child(3)').text
		email 					= doc.at_css('tr:nth-child(9) :nth-child(3)').text
		web_site 				= doc.at_css('tr:nth-child(10) :nth-child(3)').text
		latitude 				= doc.at_css('tr:nth-child(11) :nth-child(3)').text
		longitude 			= doc.at_css('tr:nth-child(12) :nth-child(3)').text
		un_locode 			= doc.at_css('tr:nth-child(13) :nth-child(3)').text
		port_type 			= doc.at_css('tr:nth-child(14) :nth-child(3)').text
		port_size 			= doc.at_css('tr:nth-child(15) :nth-child(3)').text
		'''
		Port Location		, Port Name		, Port Authority	, Address		, Phone
		Fax							, 800 Number	, Email						, Web Site	, Latitude
		Longitude				, UN/LOCODE		, Port Type				, Port Size
		'''
		port = Port.new(port_location, port_name, port_authority, address, \
		phone, fax, eight_number, email, web_site, latitude, longitude, un_locode, \
		port_type, port_size)

		return port
	end

end