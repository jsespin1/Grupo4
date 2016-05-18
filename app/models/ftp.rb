class Ftp < ActiveRecord::Base
    require 'net/ftp'
    require 'net/sftp'


    def self.getFtps
        #Obtenemos los ftps
        archivos=[]
        contador = 0
        Dir.foreach("./pedidos/") do |xml|
          if xml!="." && xml!=".."
            archivos.push(xml)
          end
        end
        archivos
    end

    def self.procesarFtps(ftps=[])
        #Aca leemos cada ftp y generamos la orden de compra
        #La idea, es que generamos una orden de compra
        #Si hay stock, generamos la OC y movemos el archivo a la carpeta de ordenes FTP despachadas
        total = 0
        ftps.each do |ftp|
            f = File.open("./pedidos/"+ftp.to_s, "r")
            #id de la OC, em línea 3
            texto = f.readline()
            texto = f.readline()
            texto = f.readline().to_s
            oc_id = texto.gsub("</id>", '') 
            oc_id = oc_id.gsub("<id>", '')
            oc_id = oc_id.tr("\n", '')
            f.close
            #Una vez obtenidos la OC id, obtenemos la orden de compra real
            total = total + revisarFtp(oc_id, ftp)
        end
    end

    def self.revisarFtp(oc_id, ftp)
        cantidad = 0
        #Obtenemos la orden de compra, Vemos si está en el sistema
        oc = Request.getOC(oc_id)
        if oc==nil
            File.delete("./pedidos/" + ftp.to_s)
        end
        if (oc != nil) and (Orden.existe(oc))
            oc = Orden.find_by(_id: oc._id)
        end
        #Si cumple con las condiciones, se envía para despacho
        canal = "ftp" # => es necesaria para comparar strings
        if (oc != nil) and (oc.canal.eql? canal) and ( oc.cantidad_despachada.to_i < oc.cantidad.to_i )
            puts "SKU: " + oc.sku.to_s + ", Cantidad: " + oc.cantidad.to_s
            cantidad = despacharFtp(oc, ftp)
        end
        cantidad
    end

    def self.despacharFtp(oc, ftp)
        #Obtenemos disponibilidad y cantidad a despachar
        cantidad = 1
        disponible = Almacen.getSkusTotal(oc.sku)
        despachar = oc.cantidad-oc.cantidad_despachada

        #Generamos factura
        factura = Request.emitir_factura(oc._id)

        if disponible == 0 || factura==nil
            puts "Error de factura o No hay productos disp."
            return cantidad
        end
        #Guardamos la orden para despachar
        puts "Se guardara la orden en la factura"
        factura.orden = oc
        factura.save
        if !oc.save or !factura.save
            return cantidad
        end


        #Despachamos según factibilidad
        if despachar <= disponible
            #Despachamos todo lo requerido
             cantidad = Almacen.revisarFormaDeDespacho(despachar, oc.sku, oc)
        else
            #Despacho parcial segñun disponibilidad
             cantidad = Almacen.revisarFormaDeDespacho(disponible, oc.sku, oc)
        end

        #Si el archivo ftp fue totalmente despachado, se elimina de la lista
        begin
          respuesta = File.delete("./pedidos/" + ftp.to_s)
          puts "FTP: " + ftp.to_s + ", Eliminado Satisfactoriamente: " + respuesta.inspect
        rescue => ex
            #Do nothing
        end
        cantidad
    end

    def self.descargarFtp
        set_url
        connect()
        contador = 0
        entries = @ftp.dir.entries("/pedidos")
        entries.each do |e|
            if e.name!='.' && e.name!='..'
                filename = e.name
                path =  Rails.root.to_s + '/pedidos/'
                @ftp.download!("/pedidos/"+filename.to_s, path+filename.to_s)
                contador = contador + 1
            end
        end
        contador
    end


    private
    def self.connect()
        p 'ESTABLISHING FTP CONNECTION'
        port = 22
        @ftp = Net::SFTP.start(@host, @username, :password => @password, :port => port)
    end 


    def self.set_url
        if Rails.env == 'development'
            @host = "mare.ing.puc.cl"
            @username = "integra4"
            @password = "dQSxFZpG"
            @path = Rails.root.to_s + '/pedidos/'
        else
            @host = "moto.ing.puc.cl"
            @username = "integra4"
            @password = "38FeEdpt"
            @path = '/home/administrator/Grupo4/pedidos/'
        end
    end


end
