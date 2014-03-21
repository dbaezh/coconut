(doc) ->
  emit doc.uuid, doc if (doc.question is "Participant Survey-es" and doc.Completado is "true") or
   (doc.question is "Exit Survey-es" and doc.Completado is "true")