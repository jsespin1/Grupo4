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
		when "1" # pollo (prueba)
			url = 'http://integra7.ing.puc.cl/api/consultar/' + sku.to_s
		when "36" # pollo (prueba)
			url = 'http://integra11.ing.puc.cl/api/consultar/' + sku.to_s	
		when "45" # celulosa (prueba)
			url = 'http://integra1.ing.puc.cl/api/consultar/' + sku.to_s	
		when "44" # nosotros (prueba)
			url = 'https://grupo4v2-fgarri.c9users.io/api/consultar/' + sku.to_s	
		end
		puts "URL -> " +url
		respuesta = Request.consultarStock(url)
		grupo8 = "26"
		if sku.eql? grupo8
			respuesta=JSON.parse(respuesta)	
		end
		stock = respuesta["stock"]
		puts "STOCK -> "+stock.inspect
		stock
	end

	def self.consultar_productos_procesados(sku)
	
	end

	def self.enviar_orden(sku,cantidad_requerida,grupo_proveedor,fecha_entrega)
		puts "CANTIDAD REQUERIDA ->"+cantidad_requerida.to_s+" | "+"STOCK -> "+  consultar_materia_prima(sku).to_s
		if cantidad_requerida<=consultar_materia_prima(sku).to_i
			puts "HAY STOCK PARA COMPRAR"
			notas="notas"
			#FALTA FECHA ENTREGA
			
			orden=Request.create_orden("b2b", cantidad_requerida, sku, Orden.getIdPropio , grupo_proveedor, Controlador.getPrecio(sku) +10, fecha_entrega, notas)
			puts "ORDEN -> " + orden.inspect
			if orden != nil
					
				respuesta=Request.enviarOC(grupo_proveedor.to_s, orden._id)
				if respuesta != nil
				
					puts "RESPUESTA -> " + respuesta.inspect
					
					if respuesta['aceptado']==true
						Orden.saveOc(orden)
						Orden.cambiarEstado(orden._id, "aceptado")
					end
				end
			end
				
		end
	end
	
	def self.compra_productos_procesados(sku, cantidad_requerida, grupo_proveedor)

	end


end
