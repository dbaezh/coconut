(doc) ->
  emit doc.uuid+ "$" + doc.lastModifiedAt,null   if doc.question is "Participant Registration-es" and doc.Completado is "true"