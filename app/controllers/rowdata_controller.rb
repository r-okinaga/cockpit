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
            ##TODO 更新したいデータが、新規作成になる
            if Rowdatum.exists?(code: param[:code])
                rowdata = Rowdatum.find(code: param[:code])
                rowdata.update_attributes(param)
            else
                rowdata = Rowdatum.new(param)
                rowdata.save!
            end
        end
        render :index
    end
end
