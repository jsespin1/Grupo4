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
				id_cliente = @oc.cliente
				sku = @oc.sku
				cantidadOrden=@oc.cantidad
				if Almacen.verificar_stock_con_pulmon(cantidadOrden,sku)
					#Aceptar OC en el sistema
					Request.receive_orden(id.to_s)
					Orden.cambiarEstado(id, "aceptada")
					Thread.new do
						generar_factura(id,id_cliente)
					end

					format.json{render json: {aceptado: true, idoc: id.to_s}, status:200}

				else # Rechazamos orden de compra, no se envia factura.
					#Rechazar OC en el sistema
					Request.reject_orden(id.to_s, "Por algún motivo, aún no implementado, lo sentimos")
					format.json{render json: {aceptado: false, idoc: id.to_s}, status:400}				
				end
			end
		end
	end


	def generar_factura(orden_id, id_grupo)
		factura = Request.emitir_factura(orden_id)
		id_factura = factura['_id']
		orden = Orden.find_by(_id: orden_id)
		orden.update_attributes(:id_factura => id_factura)
		Controlador.facturar(id_grupo,id_factura)
	end


	def transaccion
		respond_to do |format|
			if params[:idtrx] && params[:idfactura]
				id_trx = params[:idtrx]
				id_factura = params[:idfactura]
				valido=Controlador.validarTransaccion(id_trx,id_factura)
				factura = Request.obtener_factura(id_factura)
				id_oc=factura.id_oc
				oc=Request.getOC(id_oc)
				if valido
					Almacen.revisarFormaDeDespacho(oc.cantidad, oc.sku, oc._id)
					puts
					format.json {render json: {aceptado: true, idtrx: id_trx.to_s}, status:200}
				else
					format.json {render json: {aceptado: false, idtrx: id_trx.to_s}, status:200}
				end
				#Hay que validar el pago
				#validacion = Controlador.validarTrx(params[:id_trx])
				#Ahora confirmamos transaccion
			else
				format.json {render json: {description: 'Missing parameters'},status:400}
			end
		end

	end

	def getMP

		respond_to do |format|
			#Obtenemos los stock de las materias primas que producimos
			stock_33 = Controlador.getStock("38")
			stock_44 = Controlador.getStock("44")
			format.json {render json: {stock_33: stock_33, stock_44: stock_44},status:200}
		end

	end

	def abastecerMP

		respond_to do |format|
			#Debemos llamar al método abastecer MP para FABRICAR
			producido = [0, 0]
			respuesta = Abastecer.revisarMPPropias
			producido[0] = respuesta[0]
			producido[1] = respuesta[1]
			format.json {render json: {producido_33: producido[0], producido_44: producido[1]},status:200}
		end

	end

	def descargarFtp

		respond_to do |format|
			#Debemos llamar al método abastecer MP para FABRICAR
			producidos = Ftp.descargarFtp
			format.json {render json: {descargados: producidos},status:200}
		end

	end

	def procesarFtp

		respond_to do |format|
			#Debemos llamar al método abastecer MP para FABRICAR
			Ftp.procesarFtps(Ftp.getFtps)
			format.json {render json: {estado: "Se termino el proceso"},status:200}
		end

	end




end