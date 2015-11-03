json.array!(@tees) do |tee|
  json.extract! tee, :id, :color, :course_id
  json.url tee_url(tee, format: :json)
end
