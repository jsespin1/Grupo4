class Compra < ActiveRecord::Base

	def self.consultar_productos_procesados(sku)
	
	end
	
	def self.consultar_materia_prima(sku)
		case sku
		when 26 # sku_sal
			url = 'http://integra8.ing.puc.cl/api/consultar/'+sku.to_s
		when 2 # sku_huevo
			url = 'integra2.ing.puc.cl/api/consultar/'+sku.to_s
		when 23 # sku_harina
			url = 'integra7.ing.puc.cl/api/consultar/'+sku.to_s
		when 4 # sku_aceite_maravilla
			url = 'integra11.ing.puc.cl/api/consultar/'+sku.to_s
		end
		respuesta = Request.consultarStock(url)

		respuesta
	end

	def self.comprar_materia_prima(sku,cantidad_requerida,grupo_proveedor)

	end
	
	def self.compra_productos_procesados(sku, cantidad_requerida, grupo_proveedor)

	end

end
