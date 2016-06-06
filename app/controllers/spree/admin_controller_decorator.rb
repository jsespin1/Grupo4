module Spree
	Admin::BaseController.class_eval do 

	  before_filter :authorize_roles 

	  def authorize_roles 

	  end 

	end 
end