require 'rubygems'
require 'open-uri'
require 'json'
require 'pp'

#info de: https://gist.github.com/kyletcarlson/7911188

class Factura < ActiveRecord::Base


	#Metodo para emitir una factura
	def self.emitirFactura(id_factura)
		#codigo
	end
	
	#Metodo para obtener una factura
	def self.obtenerFactura(id_factura)
		#codigo

		requested_uri = 'http://mare.ing.puc.cl/facturas/'
		aux = open(requested_uri + id_factura , "Content-Type" => "application/json").read
		factura = JSON.parse(aux)

		#ruta = URI.parse("http://mare.ing.puc.cl/facturas/" + "/stock")
		#hash = get_hash("GET"+almacenID+skuId)
		#query = { almacenId: almacenID, sku: skuId}
		#skus = HTTParty.get(ruta, :query => query, :headers => hash)
		#puts "Stock -> " + skus.parsed_response.count.to_s

	end

	#Metodo para pagar una factura
	def self.pagarFactura(id_factura)
		#codigo
	end

	#Metodo para rechazar una factura
	def self.rechazarFactura(id_factura)
		#codigo
	end

	#Metodo para anular una factura
	def self.anularFactura(id_factura)
		#codigo
	end

	#Metodo para crear una boleta
	def self.crearBoleta(id_factura)
		#codigo
	end
end
