class Request < ActiveRecord::Base


	require 'hmac-sha1'

	#Bodegas
	clave_bodega = "tdk6NIzbhNfORDP"
	route_bodega = "http://integracion-2016-dev.herokuapp.com/bodega"

	def self.getAlmacenesAll
		ruta = URI.parse("http://integracion-2016-dev.herokuapp.com/bodega" + "/almacenes")
		hash = get_hash("GET")
		almacenes = HTTParty.get(ruta, :body => {}, :headers => hash)
		almacenes.to_json
		Almacen.getAlmacenes(almacenes)
	end

	def self.getSKUs(almacenID)
		ruta = URI.parse("http://integracion-2016-dev.herokuapp.com/bodega" + "/skusWithStock")
		hash = get_hash("GET"+almacenID)
		query = { almacenId: almacenID}
		skus = HTTParty.get(ruta, :query => query, :headers => hash)
		Sku.getSkus(skus)
	end

	def self.getStock(almacenID, skuId)
		ruta = URI.parse("http://integracion-2016-dev.herokuapp.com/bodega" + "/stock")
		hash = get_hash("GET"+almacenID+skuId)
		query = { almacenId: almacenID, sku: skuId}
		skus = HTTParty.get(ruta, :query => query, :headers => hash)
		Producto.getProductos(skus.parsed_response, 100)
	end

	 def self.getOC(iD)
        ruta = URI.parse("http://mare.ing.puc.cl/oc/obtener/" + iD.to_s)
        hash = {'Content-Type' => "application/json"}
        oc = HTTParty.get(ruta, :headers => hash)
        puts "OC -> " + oc.inspect
        oc
    end


	def  self.get_hash(parametros="")
		 hash = Base64.encode64((HMAC::SHA1.new("tdk6NIzbhNfORDP") << parametros).digest).strip
		 auth_header = { 'Authorization' => "INTEGRACION grupo4:"+hash.to_s,  'Content-Type' => "application/json"}
	end

	def self.get_header1
		header1 = { 'Content-type' => "application/json" }
	end
end
