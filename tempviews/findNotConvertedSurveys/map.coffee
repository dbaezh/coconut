(doc) ->
  emit doc.uuid+ "$" + doc.lastModifiedAt,null   if doc.question is "Participant Survey-es" and doc.convertedDate is undefined