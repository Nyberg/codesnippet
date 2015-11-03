json.array!(@holes) do |hole|
  json.extract! hole, :id, :course_id, :number, :par, :length, :tee_id
  json.url hole_url(hole, format: :json)
end
