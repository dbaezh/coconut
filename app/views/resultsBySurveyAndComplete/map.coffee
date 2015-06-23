(document) ->
  if document.question is "Participant Survey-es"
    if document.Completado is "true"
      emit document.question + ':true:' + document.lastModifiedAt, null
    else
      emit document.question + ':false:' + document.lastModifiedAt, null




