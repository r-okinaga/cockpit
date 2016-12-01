class RowdataController < ApplicationController
    def index
        @rowdatum = Rowdatum.all
    end
end
