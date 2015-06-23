(doc) ->
  emit doc.uuid, null  if  doc.question is "Participant Survey-es" and (doc.provider_id is undefined or doc.provider_id is null  or doc.provider_id is "")