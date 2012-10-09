# encoding: UTF-8

###########################################################################
# Test's
###########################################################################

require 'test/unit'
require './wps.rb'

class WP_XParser_Test < Test::Unit::TestCase
	@@wp_xparser = WP_XParser.new
	def test_initialize
		assert_equal WP_XParser 											, @@wp_xparser.class
		assert_equal 'http://www.worldportsource.com'	, WP_XParser::ROOT_URL
		assert_equal Mechanize::Page									, @@wp_xparser.get_worldportsource.class
	end

	def test_extract_country_codes
		country_codes = @@wp_xparser.extract_country_codes
		assert_equal Array 														, country_codes.class
		assert_equal 'ALB'														, country_codes[0]
	end

	def test_get_port_links
		ports_links = @@wp_xparser.get_port_links 'PER'
		china_ports_links = @@wp_xparser.get_port_links 'CHN'
		pait_url = 'http://www.worldportsource.com/ports/PER_Port_of_Paita_1749.php'
		
		assert_equal Array 														, ports_links.class
		assert_equal Mechanize::Page::Link						, ports_links[0].class
		assert_equal 'Port of Callao'									, ports_links[0].text
		assert_equal 'Port of Ilo'										, ports_links[1].text
		assert_equal 'Port of Matarani'								, ports_links[2].text
		assert_equal 'Port of Paita'									, ports_links[3].text
		assert_equal pait_url													, WP_XParser::ROOT_URL + ports_links[3].href
		assert_equal 'Port of Shanghai'								, china_ports_links[17].text
	end

	def test_get_port_information
		china_ports_links = @@wp_xparser.get_port_links 'CHN'
		shanghai_port = @@wp_xparser.get_port_information( china_ports_links[17] )

		assert_equal 'Shanghai'												, shanghai_port.port_location
		assert_equal 'Port of Shanghai'								, shanghai_port.port_name
		
		assert_equal 'Shanghai International Port (Group) Co., Ltd.' \
								, shanghai_port.port_authority

		assert_equal '358 East Daming Road Shanghai, Shanghai 200080 China' \
								, shanghai_port.address

		assert_equal '+8621 55333388' 								, shanghai_port.phone
		assert_equal '+8621 63217936'									, shanghai_port.fax
		assert_equal ''																, shanghai_port.eight_number
		assert_equal 'contact@portshanghai.com.cn'		, shanghai_port.email
		assert_equal 'www.portshanghai.com.cn'				, shanghai_port.web_site
		assert_equal '31° 13\' 19" N'									, shanghai_port.latitude
		assert_equal '121° 29\' 22" E'								, shanghai_port.longitude
		assert_equal 'CNSHA'													, shanghai_port.un_locode
		assert_equal 'Seaport'												, shanghai_port.port_type
		assert_equal 'Very Large'											, shanghai_port.port_size	

		usa_ports_links = @@wp_xparser.get_port_links 'USA'
		newark_port = @@wp_xparser.get_port_information( usa_ports_links[58] )

		assert_equal Array 														, usa_ports_links.class
		assert_equal Mechanize::Page::Link						, usa_ports_links[0].class
		assert_equal 'Newark'													, newark_port.port_location
		assert_equal 'Port of Newark'									, newark_port.port_name
		assert_equal 'The Port Authority of New York and New Jersey' \
								, newark_port.port_authority
		assert_equal 'Newark, NJ United States'				, newark_port.address
		assert_equal ''																, newark_port.phone
		assert_equal ''																, newark_port.fax
		assert_equal ''																, newark_port.eight_number
		assert_equal ''																, newark_port.email
		assert_equal 'www.panynj.gov'									, newark_port.web_site
		assert_equal '40° 42\' 0" N'									, newark_port.latitude
		assert_equal '74° 8\' 22" W'									, newark_port.longitude
		assert_equal ''																, newark_port.un_locode
		assert_equal 'Deepwater Seaport'							, newark_port.port_type
		assert_equal 'Very Large'											, newark_port.port_size

		peru_ports_links = @@wp_xparser.get_port_links 'PER'
		callao_port = @@wp_xparser.get_port_information ( peru_ports_links[0] )

		assert_equal Port 														, callao_port.class
		assert_equal 'Callao'													, callao_port.port_location
		assert_equal 'Port of Callao'									, callao_port.port_name
		assert_equal 'Empresa Nacional de Puertos S.A.' \
								, callao_port.port_authority
		assert_equal 'Av. Contralmirante Raygada 110 Callao Peru' \
								, callao_port.address
		assert_equal '51 1 429-9210'									, callao_port.phone
		assert_equal '51 1 469-1010'									, callao_port.fax
		assert_equal ''																, callao_port.eight_number
		assert_equal ''																, callao_port.email
		assert_equal 'www.enapu.com.pe'								, callao_port.web_site
		assert_equal '12° 2\' 43" S'									,	callao_port.latitude
		assert_equal 'Large'													, callao_port.port_size

	end
end