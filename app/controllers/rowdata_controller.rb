class RowdataController < ApplicationController

    def index
        @rowdatum = Rowdatum.all
        respond_to do |format|
            format.html
            format.json { render json: @rowdatum}
        end
    end

    def create
        p JSON.parse(request.body.read)
        render :index
    end
end
