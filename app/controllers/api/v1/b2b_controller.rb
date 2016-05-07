class Api::V1::B2bController < ApplicationController

	respond_to :json, :html

	def getStock
		respond_to do |format|
			if params[:_id]
				id = params[:_id].to_i
				respuesta = Controlador.getStock(params[:_id].to_i)
				total = respuesta.to_i
				if total
					format.json {render json: {stock: total, sku: id},status:200}
				else
					format.json {render json: {description: 'No se pudo procesar la solicitud'},status:404}
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
				sku = @oc.sku
				cantidadOrden=@oc.cantidad
				if Almacen.verificar_stock_sin_pulmon(cantidadOrden,sku)
					format.json {render json: {aceptado: true, idoc: id.to_s}, status:200}
					generar_factura(id,id_cliente)
				elsif Almacen.verificar_stock_con_pulmon(cantidadOrden,sku)
					format.json{render json: {aceptado: true, idoc: id.to_s}, status:200}
					generar_factura(id,id_cliente)
				else # Rechazamos orden de compra, no se envia factura.
					format.json{render json: {aceptado: false, idoc: id.to_s}, status:400}				
				end
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
				valido=Controlador.validarTransaccion(id_trx,id_factura)
				factura = Request.obtener_factura(id_factura)
				id_oc=factura.id_oc
				oc=Request.getOC(id_oc)
				if valido
					Almacen.revisarFormaDeDespacho(oc.cantida, oc.sku, oc._id)
					format.json {render json: {aceptado: true, idoc: id.to_s}, status:200}
				else
					format.json {render json: {aceptado: false, idoc: id.to_s}, status:200}
				end
				#Hay que validar el pago
				#validacion = Controlador.validarTrx(params[:id_trx])
				#Ahora confirmamos transaccion
			else
				format.json {render json: {description: 'Missing parameters'},status:400}
			end
		end

	end




end