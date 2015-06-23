(doc) ->
  emit doc.uuid, null  if doc.question is "Participant Registration-es" and doc.Completado is "true"