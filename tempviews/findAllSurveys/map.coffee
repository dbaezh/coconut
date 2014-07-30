(doc) ->
  if doc.Completado is "true"
    emit doc.uuid+ "$" + "true$" + doc.lastModifiedAt,null   if doc.question is "Participant Survey-es"
  else
    emit doc.uuid+ "$" + "false$" + doc.lastModifiedAt,null   if doc.question is "Participant Survey-es"