class AlmacenController < ApplicationController

	def index
		#Promocion.postFacebook()
		#Promocion.postTwitter()
		#puts "gol"
		@almacenes = Request.getAlmacenesAll
		@orden = Orden.all
		@factura = Factura.all
<<<<<<< HEAD
		Promocion.amqp_consumer
=======
		Promocion.postTwitter(38)

>>>>>>> 563b4d6935b1155d83b9097d6f0ab26827b0a87b
		#puts "SE LLAMO CREAR BOLETA 1"
		#Boletum.crearBoleta("38", 2, "mi casa",  (1513*1.19*2).ceil)
		#puts "SE LLAMO CREAR BOLETA"
		#Ftp.procesarFtps(Ftp.getFtps)
		#Compra.consultar_materia_prima("26")
		#oc_id = "57145e4cf77d320300f0deb9"
		#ftp_file = "1460952637328.xml"
		#Ftp.revisarFtp(oc_id, ftp_file)
		#Abastecer.revisarMPPropias
		#Ftp.descargarFtp
		#Request.moverStock('571262b6a980ba030058a7aa','571262aaa980ba030058a242')
		#Almacen.moverAlmacenDespacho("38","1")
		#Almacen.moverAlmacenDespacho("38","1")
		#almacenes = Request.getAlmacenesAll
		#almacenes.each do |a|
			#puts "Almacen ->" + a._id.to_s + " " + a.usedSpace.to_s
		#Almacen.moverAlmacenDespacho
		#almacenes = Request.getAlmacenesAll
		#almacenes.each do |a|
		#	puts "Almacen ->" + a._id.to_s + " " + a.usedSpace.to_s
			#skus = Request.getSKUs(a._id)
			#productos = Request.getStock(a._id, "38",5)
			#puts "   PRODUCTOS " + productos.count.to_s

			#skus = Request.getSKUs(a._id)
			#puts "   SKUs " + skus.inspect
		#end
		#numero = Request.getStock('571262aaa980ba030058a241','16')
		#almacenes = Request.getAlmacenesAll
		#puts "CHAMESITO TIENE SUEÑO " + numero.inspect
		#puts "prueba jarita ->" + Compra.consultar_materia_prima(26).inspect
		#origin/compras
		#El siguiente método gatilla el proceso de compra ficticio SKU:38 QTY:340
		#Controlador.facturaFicticio("571682b543c20b03003d9ab7")
		#Almacen.revisarAlmacenRecepcion
		#Request.create_orden('b2b', 4, '38', '571262b8a980ba030058ab52', '571262b8a980ba030058ab52', 1513, DateTime.current + 6.days, 'jpp' )
		#@oc = Request.getOC("57127d2e8a9e6506000b998a")
		#id = "57136f3ba7aa2f03002639f4"
		#sku = 38
		#qty = 300
		#Controlador.procesar_oc(id)
		#Request.create_orden('b2b', 4, '38', '571262b8a980ba030058ab52', '571262b8a980ba030058ab52', 1513, 3563209336999, 'jpp' )
		#@oc = Request.getOC("57127d2e8a9e6506000b998a")
		#Ftp.showls
	end


	def show
		puts "gol"
		@almacen = params[:almacen]
		@skus = Request.getSKUs(params[:almacen]['_id'])
		#Obtenemos
		#productos = Request.getStock(params[:almacen]['_id'], s._id)
	end

end
