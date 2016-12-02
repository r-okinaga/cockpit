class Api::RowdataController < ApplicationController

    skip_before_filter :verify_authenticity_token

end