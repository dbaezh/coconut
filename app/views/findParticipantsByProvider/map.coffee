(doc) ->
  emit doc.provider_id, doc  if doc.question is "Participant Registration-es" and doc.Completado is "true" and doc.hasOwnProperty('provider_id')


