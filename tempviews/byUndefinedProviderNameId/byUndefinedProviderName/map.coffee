(doc) ->
  emit doc.id, null  if doc.question is "Participant Registration-es" and doc.provider_id isnt "undefined" and doc.provider_id? and (not doc.provider_name? or doc.provider_name is "undefined")
