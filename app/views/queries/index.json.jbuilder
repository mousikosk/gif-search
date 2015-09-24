json.array!(@queries) do |query|
  json.extract! query, :id, :term
  json.url query_url(query, format: :json)
end
