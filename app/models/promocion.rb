class Promocion < ActiveRecord::Base

  def self.postFacebook()
    link = 'http://www.radioagricultura.cl/wp-content/uploads/2016/05/getimage1.jpg'
    me = FbGraph::User.me('EAADxZBBU7tuEBADW6oxBGVbOGwznZB2t02aem8cHDxnJMZCmHx67Bh4wHrPGf3OWegji4mIr91PJOaz3lvdHJuiww7BFC55EZCxALp9ZA5SgIVnGlmczFXhDNFqfkCzThLXDVlgBs5h8fh2FYaX929aBq3nRL75sZD')
    me.feed!(
      message: 'prueba',
      picture: 'http://www.lavanguardia.com/r/GODO/LV/p3/WebSite/2016/04/03/Recortada/Spain_Soccer_La_Liga-048bd_20160402225435-k0G-U40854754499BEC-992x558@LaVanguardia-Web.jpg',
      link: 'http://www.lavanguardia.com/r/GODO/LV/p3/WebSite/2016/04/03/Recortada/Spain_Soccer_La_Liga-048bd_20160402225435-k0G-U40854754499BEC-992x558@LaVanguardia-Web.jpg',
      name: 'FbGraph',
      description: 'A Ruby wrapper for Facebook Graph API'
    )
  end

  def self.postTwitter()
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = "DtsQzOCl6WxHYypc2Zrl69ULL"
      config.consumer_secret = "zLiYwfYlCIAYITQ4YoPXX8abUEfDZJTxCf0BgiqbK7egjavHsb"
      config.access_token = "747540484193685504-BVBgqItmbb1dKkT45DQEkTsBgFJzeTZ"
      config.access_token_secret = "aNKKsfkdl4Gs4UOQvqjLrWVsXt8FNxVkTR9NEkw2faq5G"
    end
    client.update_with_media("PRUEBA", open('http://www.lavanguardia.com/r/GODO/LV/p3/WebSite/2016/04/03/Recortada/Spain_Soccer_La_Liga-048bd_20160402225435-k0G-U40854754499BEC-992x558@LaVanguardia-Web.jpg'))
  end

end
