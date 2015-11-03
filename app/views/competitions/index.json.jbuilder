json.array!(@competitions) do |competition|
  json.extract! competition, :id, :name, :title, :content, :club_id, :date
  json.url competition_url(competition, format: :json)
end
