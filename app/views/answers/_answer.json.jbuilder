json.extract! answer, :id, :body, :created_at, :updated_at, :author_id

json.files answer.files do |file|
  json.id file.id
  json.name file.filename
end

json.links answer.links do |link|
  json.id link.id
  json.name link.name
  json.url link.url
end

json.comments answer.comments do |comment|
  json.id comment.id
  json.body comment.body
  json.author comment.author
end

# json.votes answer.votes do |vote|
#   json.id vote.id
#   json.score vote.score
# end
