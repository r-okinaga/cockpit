json.array!(@rowdatum) do |rowdata|
    json.extract! rowdata, :id, :title, :content
    json.url rowdata_url(rowdata, format: :json)
end