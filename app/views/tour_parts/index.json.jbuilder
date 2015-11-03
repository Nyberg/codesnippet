json.array!(@tour_parts) do |tour_part|
  json.extract! tour_part, :id, :name, :content, :course_id, :competition_id, :tee_id
  json.url tour_part_url(tour_part, format: :json)
end
