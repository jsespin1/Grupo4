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
        connect()
        #@carpeta = @ftp.getdir()
        #puts @carpeta.inspect
        puts @ftp.dir.entries("/pedidos").inspect
        #@ftp.dir.foreach("/pedidos") do |entry|
		 #   puts entry.name
		#  end
    end


	private
    def self.connect()
        p 'ESTABLISH FTP CONNECTION'
        host = "mare.ing.puc.cl"
        port = 22
        username = "integra4"
        password = "dQSxFZpG"
        session = Net::SSH.start(host, username, :password => password, :port => port)
        @ftp = Net::SFTP.start(host, username, :password => password, :port => port)
        #@ftp = Net::FTP.new
        #@ftp.debug_mode = true
        #@ftp.passive = true
        #@ftp.connect(host,port)
        #@ftp.login(username, password)
    end 

    def self.close_connection
        p 'CLOSE FTP CONNECTION'
        @ftp.close
    end


end
