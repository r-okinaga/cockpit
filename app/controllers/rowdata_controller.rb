class RowdataController < ApplicationController
    skip_before_filter :verify_authenticity_token

    def index
        @rowdatum = Rowdatum.all
        respond_to do |format|
            format.html
            format.json { render json: @rowdatum }
        end
    end

    def create
        params = JSON.parse request.body.read

        params.each do |param|
            if Rowdatum.exists?(code: param["code"])
                rowdata = Rowdatum.find_by_code(param["code"])
                rowdata.update_attributes(param)
            else
                rowdata = Rowdatum.new(param)
                rowdata.save!
            end
        end
        render :index
    end

    def show
        rowdata = Rowdatum.new

        case params[:cmd]
            when 'save'
                if rowdata.sheet_save(params[:sheet_id])
                    respond_to do |format|
                        format.html
                        format.json { render json: :success }
                    end
                end
            when 'load'

            else
                raise "Unknown command."
        end
    end

end
