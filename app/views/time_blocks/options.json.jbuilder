json.array!(@events) do |event|
  json.internal_id event[:internal_id]
  json.start event[:start]
  json.end event[:finish]
  json.title "Disponible"
  json.stick true
end
