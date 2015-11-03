json.array!(@scores) do |score|
  json.extract! score, :id, :user_id, :round_id, :tee_id, :hole_id, :score
  json.url score_url(score, format: :json)
end
