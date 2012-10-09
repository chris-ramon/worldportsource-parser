class Port
	attr_accessor :port_location, :port_name, :port_authority, \
	:address, :phone, :fax, :eight_number, :email, :web_site, \
	:latitude, :longitude, :un_locode, :port_type, :port_size

	def initialize(port_location=nil, port_name=nil, port_authority=nil,
		address=nil, phone=nil, fax=nil, eight_number=nil, email=nil,
		web_site=nil, latitude=nil, longitude=nil, un_locode=nil,
		port_type=nil, port_size=nil)

		@port_location = port_location
		@port_name = port_name
		@port_authority = port_authority
		@address = address
		@phone = phone
		@fax = fax
		@eight_number = eight_number
		@email = email
		@web_site = web_site
		@latitude = latitude
		@longitude = longitude
		@un_locode = un_locode
		@port_type = port_type
		@port_size = port_size
	end
end
