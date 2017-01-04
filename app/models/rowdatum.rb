class Rowdatum < ApplicationRecord
    require 'google/apis/sheets_v4'
    require 'googleauth'
    require 'googleauth/stores/file_token_store'
    require 'fileutils'

    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
    APPLICATION_NAME = 'kensho'
    CLIENT_SECRETS_PATH = "#{Rails.root}/client_id.json"
    CREDENTIALS_PATH = File.join(
        Dir.home,
        '.credentials',
        "sheets.googleapis.com-ruby-quickstart.yaml"
    )
    SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY

    def save_sheet_data(sheet_id)
        @service = Google::Apis::SheetsV4::SheetsService.new
        authorize
        sheet_data = get_data(sheet_id)

        if sheet_data.present?
            sheet_data.values.each do |row|
                Rails.logger.debug "#{row[0]}, #{row[4]}"
            end
        end
    end

    private
    def get_data(sheet_id)
        @service.get_spreadsheet_values(sheet_id, data_range)
    end

    def data_range
        'PM1!A2:E100'
    end

    def authorize
        @service.client_options.application_name = APPLICATION_NAME
        FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

        client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
        token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
        authorizer = Google::Auth::UserAuthorizer.new(
            client_id, SCOPE, token_store)
        user_id = 'okinaga'
        credentials = authorizer.get_credentials(user_id)
        if credentials.nil?
            url = authorizer.get_authorization_url(
                base_url: OOB_URI)
            puts "Open the following URL in the browser and enter the " +
                     "resulting code after authorization"
            puts url
            code = gets
            credentials = authorizer.get_and_store_credentials_from_code(
                user_id: user_id, code: code, base_url: OOB_URI)
        end
        @service.authorization = credentials
    end
end
