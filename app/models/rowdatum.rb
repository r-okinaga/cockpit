class Rowdatum < ApplicationRecord
    require 'google/apis/sheets_v4'
    require 'googleauth'
    require 'googleauth/stores/file_token_store'
    require 'fileutils'
    require 'net/https'
    require 'json'

    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
    APPLICATION_NAME = 'kensho'
    CLIENT_SECRETS_PATH = "#{Rails.root}/client_id.json"
    CREDENTIALS_PATH = File.join(
        Dir.home,
        '.credentials',
        "sheets.googleapis.com-ruby-quickstart.yaml"
    )
    SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY

    CODE = 0
    CLIENT = 1
    STAFF = 2
    URIAGE = 3
    GENKA = 4

    def save_sheet_data(sheet_id)
        @service = Google::Apis::SheetsV4::SheetsService.new
        authorize
        sheet_data = get_data(sheet_id)

        if sheet_data.present?
            sheet_data.values.each do |row|
                if Rowdatum.exists?(code: row[CODE])
                    rowdata = Rowdatum.find_by_code(row[CODE])
                    rowdata.div = row[CLIENT]
                    rowdata.staff = row[STAFF]
                    rowdata.uriage = str_to_decimal(row[URIAGE]).to_i
                    rowdata.genka = str_to_decimal(row[GENKA]).to_i
                    rowdata.save!
                else
                    Rowdatum.create(
                        code: row[CODE],
                        div: row[CLIENT],
                        staff: row[STAFF],
                        uriage: row[URIAGE],
                        genka: row[GENKA]
                    )
                end
            end
        end
    end

    def load_sheet_data(sheet_id)
        @service = Google::Apis::SheetsV4::SheetsService.new
        authorize

        uri = URI.parse("https://sheets.googleapis.com/v4/spreadsheets/#{sheet_id}:batchUpdate")
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        req = Net::HTTP::Post.new(uri.request_uri)
        req["Content-Type"] = "application/json"
        req.body = create_json_data
        https.request(req)

    end

    private
    def create_json_data
        rows = []
        rowdatum = Rowdatum.all
        rowdatum.each do |row|
            if row.code.present?
                rows << {
                    "values": [
                        {
                            "userEnteredValue": {
                                "stringValue": row.code
                            }
                        },
                        {
                            "userEnteredValue": {
                                "stringValue": row.div
                            }
                        },
                        {
                            "userEnteredValue": {
                                "stringValue": row.staff
                            }
                        },
                        {
                            "userEnteredValue": {
                                "numberValue": row.uriage
                            }
                        },
                        {
                            "userEnteredValue": {
                                "numberValue": row.genka
                            }
                        }
                    ]
                }
            end
        end

        data = {
            "requests": [
                {
                    "updateCells": {
                        "start": {
                            "sheetId": 0,
                            "rowIndex": 1,
                            "columnIndex": 0
                        },
                        "rows": rows,
                        "fields": "userEnteredValue"
                    }
                }
            ]
        }
        data.to_json
    end

    def get_data(sheet_id)
        @service.get_spreadsheet_values(sheet_id, data_range)
    end

    def data_range
        'PM1!A2:E100'
    end

    def str_to_decimal(str)
        str = str.delete('¥')
        str.delete(',')
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
