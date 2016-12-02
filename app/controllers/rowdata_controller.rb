class RowdataController < ApplicationController
    skip_before_filter :verify_authenticity_token

    def index
        @rowdatum = Rowdatum.all
        respond_to do |format|
            format.html
            format.json { render json: @rowdatum}
        end
    end

    def create
        params = JSON.parse request.body.read

        params.each do |param|
            @rowdata = Rowdatum.new(param)
            if @rowdata.save

            end
        end
        render :index
    end
end
