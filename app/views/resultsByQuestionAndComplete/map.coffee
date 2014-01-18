(document) ->
  if document.collection is "result"
    if document.Completado is "true"
      emit document.question + ':true:' + document.lastModifiedAt, null
    else
      emit document.question + ':false:' + document.lastModifiedAt, null
