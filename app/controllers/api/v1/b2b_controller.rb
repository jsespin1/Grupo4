class Api::V1::B2bController < ApplicationController

	respond_to :json, :html

	def getStock
		respond_to do |format|
			if params[:_id]
				id = params[:_id].to_i
				respuesta = Controlador.getStock(params[:_id].to_i)
				total = respuesta.to_i
				if total > 0
					format.json {render json: {stock: total, sku: id},status:200}
				else
					format.json {render json: {description: 'No hay productos de ese SKU'},status:404}
				end
			else
				format.json {render json: {description: 'Missing parameters'},status:400}
			end
		end

	end

	def analizarOC
		respond_to do |format|
			if params[:_idorden]
				id = params[:_idorden]
				@oc = Request.getOC(id)
				id_cliente = @oc.proveedor
				#luego se debe revisar el stock, sumando todos los almacenes
				sku = @oc.sku
				cantidadOrden=@oc.cantidad
				# Logica de nuestra de nuestro programa
				if cantidadOrden<=Almacen.getSkusTotal(sku)
					format.json{render json: {aceptado: true, idoc: id.to_s}, status:200}
					#LLAMAR AL METODO QUE VMOS A CREAR
				else
					format.json{render json: {aceptado: false, idoc: id.to_s}, status: 200}
					#generar_factura(id,id_cliente) #NO VA AQUI !=!=!=!=DIESFUOEIFUSEOIFUSO. (VA EN EL IF DE ARRIBA)
				end
			else
				format.json {render json: {description: 'Missing parameters'},status:400}
			end
		end
	end

	def generar_factura(orden_id, id_grupo)
		factura = Request.emitir_factura(orden_id)
		id_factura = factura['_id']
		Controlador.facturar(id_grupo,id_factura)
	end


	def transaccion
		respond_to do |format|
			if params[:id_trx] && params[:id_factura]
				id_trx = params[:id_trx]
				id_factura = params[:id_factura]
				#Hay que validar el pago
				#validacion = Controlador.validarTrx(params[:id_trx])
				#Ahora confirmamos transaccion
				transaccion = Transaccion.getTran(Request.obtener_transaccion(id_trx))
				if total > 0
					format.json {render json: {stock: total, sku: id},status:200}
				else
					format.json {render json: {description: 'No hay productos de ese SKU'},status:404}
				end
			else
				format.json {render json: {description: 'Missing parameters'},status:400}
			end
		end

	end




end