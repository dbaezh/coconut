(doc) ->
  emit doc.id, null  if doc.question is "Participant Registration-es" and doc.Provincia is "DISTRITO NACIONAL" and (not doc.user_name? or doc.user_name is "undefined")
