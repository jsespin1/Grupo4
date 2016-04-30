class Request < ActiveRecord::Base


	require 'hmac-sha1'

	#Bodegas
	clave_bodega = "tdk6NIzbhNfORDP"
	route_bodega = "http://integracion-2016-dev.herokuapp.com/bodega"

	def self.getAlmacenesAll
		ruta = URI.parse("http://integracion-2016-dev.herokuapp.com/bodega" + "/almacenes".to_s)
		hash = get_hash("GET")
		almacenes = HTTParty.get(ruta, :body => {}, :headers => hash)
		almacenes.to_json
	end

	def  self.get_hash(parametros="")
		 hash = Base64.encode64((HMAC::SHA1.new("tdk6NIzbhNfORDP") << parametros).digest).strip
		 auth_header = { 'Authorization' => "INTEGRACION grupo4:"+hash.to_s,  'Content-Type' => "application/json"}
	end

	def self.get_header1
		header1 = { 'Content-type' => "application/json" }
	end
end
