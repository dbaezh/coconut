(doc) ->
  emit doc.activity_id, doc if doc.question is "Attendance List" and doc.hasOwnProperty('activity_id')


