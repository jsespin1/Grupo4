class OrdenController < ApplicationController

    def index
        @orden = Orden.all
    end
end
