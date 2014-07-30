(doc) ->
  emit doc.uuid, null  if doc.question is "Participant Survey-es" and doc.Completado is "true"