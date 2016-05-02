class Ftp < ActiveRecord::Base
	require 'net/ftp'
	require 'net/sftp'


	def self.download(credentials,path,filename)
        p 'FTP DOWNLOAD'
        connect(credentials)
        @ftp.chdir("#{credentials.directory_path}")
        @ftp.getbinaryfile(filename,"#{path}#{filename}")
    end 

    def self.showls
        set_url
        connect()
        entries = @ftp.dir.entries("/pedidos")
        entries.each do |e|
            if e.name!='.' && e.name!='..'
                filename = e.name
                path =  Rails.root.to_s + '/pedidos/'
                puts "RUTA -> " + path
                @ftp.download!("/pedidos/"+filename.to_s, path+filename.to_s)
            end
        end
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

    

    def self.close_connection
        p 'CLOSE FTP CONNECTION'
        @ftp.close
    end


end
