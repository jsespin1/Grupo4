class Api::V1::B2bController < ApplicationController

	respond_to :json, :html

 	protect_from_forgery with: :null_session
	skip_before_filter  :verify_authenticity_token

	# ------------------------------------Get Stock-------------------------------------- #
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

	# ------------------------------------Recibir OC (VENTA)-------------------------------------- #
	def analizarOC
		respond_to do |format|
			if params[:_idorden]
				id = params[:_idorden]
				oc = Request.getOC(id)
				if oc!=nil
					id_cliente = oc.cliente
					sku = oc.sku
					cantidadOrden = oc.cantidad
				end
				if oc!=nil and !(Orden.existe(oc)) and Orden.verificar_oc(oc) and Almacen.verificar_stock_con_pulmon(cantidadOrden,sku) 
					#Aceptar OC en el sistema
					Orden.saveOc(oc)
					Request.receive_orden(id.to_s)
					Orden.cambiarEstado(id, "aceptada")
					Thread.new do
						generar_factura(id,id_cliente)
					end

					format.json{render json: {aceptado: true, idoc: id.to_s}, status:200}

				else # Rechazamos orden de compra, no se envia factura.
					#Rechazar OC en el sistema
					Request.reject_orden(id.to_s, "Sin stock u orden inválida")
					format.json{render json: {aceptado: false, idoc: id.to_s}, status:400}				
				end
			end
		end
	end


	def generar_factura(orden_id, id_grupo)
		factura = Request.emitir_factura(orden_id)
		puts "Factura Generada -> " + factura.inspect
		if factura != nil
			id_factura = factura['_id']
			orden = Orden.find_by(_id: orden_id)
			orden.update_attributes(:id_factura => id_factura)
			Controlador.facturar(id_grupo,id_factura)
		end
	end

	# ---------------------------------------Recibir Factura (COMPRA)---------------------------------------- #

	#Recibimos factura -> Verificar que está correcta para pagarla
	def facturar
		respond_to do |format|
			if params[:id_factura]
				id = params[:id_factura]
				factura = Request.obtener_factura(id)
				puts factura.inspect
				if factura!=nil and Factura.verificar_compra(factura)
					puts "paso primer if factura"
					#Se procede a pagar la factura
					transaccion = pagar_factura(factura)
					puts "Transaccion -> " + transaccion.inspect
					if transaccion != nil
						puts "TRX != null"
						Thread.new do
							enviar_transaccion(transaccion._id, id, factura.proveedor)
						end
						facturaPagada=Request.pagar_factura(id)
						puts "Factura Pagada"  +  facturaPagada.inspect
						if facturaPagada != nil
							factura.estado_pago = "pagada"
							Factura.saveFactura(factura)
							Orden.where(_id:factura.id_oc).update(id_factura:factura._id)
						end
					else
						puts "TRX = null"
						
						Factura.saveFactura(factura)
						Orden.where(_id:factura.id_oc).update(id_factura:factura._id)
						
						
						#Si no podemos pagar, queda con estado PENDIENTE
					end
					format.json {render json: {validado: true, idfactura: id}, status:200}
				else
					format.json {render json: {validado: false, idfactura: id}, status:200}
				end
			else
				format.json {render json: {description: 'Missing parameters'},status:400}
			end
		end
		
	end

	def pagar_factura(factura)
		#Obtenemos monto y cuenta de destino -> pagamos
		monto = factura.valor_total
		cuenta_origen = Finanza.getCuentaPropia
		cuenta_destino = Finanza.getCuentaDestino(factura.proveedor)
		transaccion = Finanza.transferir(monto, cuenta_origen, cuenta_destino)
	end

	def enviar_transaccion(id_trx, id_factura, id_cliente)
		Controlador.enviar_transaccion(id_trx, id_factura, id_cliente)
	end

	# ------------------------------------Recibir TRX y Factura (VENTA)-------------------------------------- #
	def transaccion
		respond_to do |format|
			if params[:idtrx] && params[:idfactura]
				id_trx = params[:idtrx]
				id_factura = params[:idfactura]
				valido = Controlador.validarTransaccion(id_trx,id_factura)
				factura = Request.obtener_factura(id_factura)
				if factura != nil
					#Vemos en BD si está la OC, para comprobar que se hizo la solicitud
					id_oc = factura.id_oc
					oc = Orden.find_by(_id: id_oc)
				end
				if factura!=nil and oc and Factura.verificar_venta(factura) and valido
					puts "La TRX, Factura y OC corresponden"
					#Si todo está en orden, DESPACHAMOS
					Thread.new do
							Almacen.revisarFormaDeDespacho(oc.cantidad, oc.sku, oc)
					end
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





	# ------------------------------------API Privada-------------------------------------- #

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
			cantidad = Ftp.procesarFtps(Ftp.getFtps)
			format.json {render json: {estado: "Se termino el proceso", cantidad: cantidad}, status:200}
		end

	end
	
	def comprarMP
		respond_to do |format|
			puts "HOLAAAAAAA"
			if params[:sku] and params[:cantidad] and params[:proveedor]
				puts "ENTRO AL PRIMER IF"
				sku =params[:sku]
				cantidad= params[:cantidad]
				proveedor = params[:proveedor]
				todoBien=Compra.enviar_orden(sku,cantidad,proveedor,DateTime.current+ 1.hours)	
				puts todoBien
				if todoBien
					format.json {render json: {status: todoBien},status:200}
				else
					puts "ACAAAAAAAAAAAAAAAAAAA"
					format.json {render json: {status: todoBien},status:200}
				end
			else
				format.json {render json: {description: 'Missing parameters'},status:400}	
			end
		end
	end
	
	



end