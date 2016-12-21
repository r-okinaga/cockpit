module Api
    class RowdataController < ApplicationController
        skip_before_filter :verify_authenticity_token

        def index
            @rowdatum = Rowdatum.all
            render json: @rowdatum
        end


    end
end
