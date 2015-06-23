(doc) ->
  emit doc.uuid, null if (doc.question is "Participant Survey-es" and doc.Completado is "true") or
   (doc.question is "Exit Survey-es" and doc.Completado is "true")