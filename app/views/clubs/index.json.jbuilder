json.array!(@clubs) do |club|
  json.extract! club, :id, :name, :website, :img
  json.url club_url(club, format: :json)
end
