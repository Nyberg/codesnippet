json.array!(@courses) do |course|
  json.extract! course, :id, :name, :content, :club_id, :holes
  json.url course_url(course, format: :json)
end
