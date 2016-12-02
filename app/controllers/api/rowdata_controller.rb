class Api::RowdataController < ApplicationController

    skip_before_filter :verify_authenticity_token

    def create

        json_request = JSON.parse(request.body.read)
        if json_request.present?
            p json_request
        end
    end
end