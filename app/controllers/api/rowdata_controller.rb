module Api
    class RowdataController < ApplicationController
        skip_before_filter :verify_authenticity_token

        def index
            @rowdatum = Rowdatum.all
            render json: @rowdatum
        end


        def s_save
            rowdata =  Rowdatum.new
            if rowdata.sheet_save(params[:sheet_id])
                render json: :success
            end
        end
    end
end
