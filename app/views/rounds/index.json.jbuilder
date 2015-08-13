json.array!(@rounds) do |round|
  json.extract! round, :id, :user_id, :course_id, :competition_id, :tee_id, :tour_part_id, :score, :division
  json.url round_url(round, format: :json)
end
