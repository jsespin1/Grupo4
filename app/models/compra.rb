class Compra < ActiveRecord::Base

	#Se encarga de comprar productos a otros grupos
	
	def self.consultar_materia_prima(sku)
		case sku
		when "26" # sku_sal
			url = 'http://integra8.ing.puc.cl/api/consultar/' + sku.to_s
		when "2" # sku_huevo
			url = 'http://integra2.ing.puc.cl/api/consultar/' + sku.to_s
		when "23" # sku_harina
			url = 'http://integra7.ing.puc.cl/api/consultar/' + sku.to_s
		when "4" # sku_aceite_maravilla
			url = 'http://integra11.ing.puc.cl/api/consultar/' + sku.to_s
		end
		puts "URL -> " +url
		respuesta = Request.consultarStock(url)
		stock = respuesta['stock']
		puts "STOCK -> "+stock.inspect
		stock
	end

	def self.consultar_productos_procesados(sku)
	
	end

	def self.enviar_orden(sku,cantidad_requerida,grupo_proveedor,fecha_entrega)
		puts "CANTIDAD REQUERIDA ->"+cantidad_requerida.to_s+" | "+"STOCK -> "+  consultar_materia_prima(sku).to_s
		if cantidad_requerida<=consultar_materia_prima(sku).to_i
	#		puts "HAY STOCK PARA COMPRAR"
	#		#FALTA FECHA ENTREGA
	#		orden=Request.create_orden(b2b, cantidad_requerida, sku, Orden.getIdPropio , grupo_proveedor, Controlador.getPrecio(sku)+1, fecha_entrega, notas)
	#		puts "ORDEN -> " + orden.inspect
	#		respuesta=Request.enviarOC(grupo_proveedor, orden._id).parsed_response
	#		puts "RESPUESTA -> " + respuesta.inspect
	#		if respuesta['aceptado']==true
	#			Orden.saveOc(orden)
	#			cambiarEstado(orden._id, "aceptado")
	#			
	#		end
		end
	end
	
	def self.compra_productos_procesados(sku, cantidad_requerida, grupo_proveedor)

	end


end
