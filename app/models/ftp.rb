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
            despacharFtp(oc_id, ftp)
        end
    end

    def self.revisarFtp(oc_id, ftp)
        #Obtenemos la orden de compra
        oc = Request.getOC(oc_id)
        #Si cumple con las condiciones, se envía para despacho
        if oc.canal=="ftp" && oc.cantidad_despachada < oc.cantidad_despachada
            despacharFtp(oc_id)
        end
    end

    def self.despacharFtp(oc_id, ftp)
        #Obtenemos la orden de compra
        oc = Request.getOC(oc_id)
        #Obtenemos disponibilidad y cantidad a despachar
        disponible = Almacen.getSkusTotal(oc.sku)
        despachar = oc.cantidad-oc.cantidad_despachada

        #Generamos factura
        factura = Request.emitir_factura(oc._id)

        if disponible == 0 || factura==nil
            return
        end

        #Despachamos según factibilidad
        if despachar <= disponible
            #Despachamos todo lo requerido
            #METODO DESPACHAR!!!!!

        else
            #Despacho parcial segñun disponibilidad
            #METODO DESPACHAR!!!!!
        end

        #Si el archivo ftp fue totalmente despachado, se elimina de la lista
        if oc.cantidad_despachada ==  oc.cantidad && ftp != nil
            File.delete("./pedidos/" + ftp)
            puts "FTP: " + ftp.to_s + ", Eliminado Satisfactoriamente"
        end
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
        puts "Se Descargaron: " + contador.to_s + " solicitudes FTP"
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
