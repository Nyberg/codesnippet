json.array!(@imports) do |import|
  json.extract! import, :id, :comp_name, :tour_name, :date, :club
  json.url import_url(import, format: :json)
end
