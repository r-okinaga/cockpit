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
            if Rowdatum.exists?(code: params[:code])
                rowdata = Rowdatum.find(code: params[:code])
                rowdata.update_attributes(params)
            else
                rowdata = Rowdatum.new(param)
                rowdata.save!
            end
        end
        render :index
    end
end
