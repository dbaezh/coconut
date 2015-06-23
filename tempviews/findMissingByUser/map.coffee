(doc) ->
  val = ""
  val += '"Nombre":"' + doc.Nombre + '"'
  val += ',' +'"Apellido":"' + doc.Apellido + '"'
  val += ',' +'"Question":"' + doc.question + '"'
  val += ',' +'"UUID":"' + doc.uuid + '"'

  emit doc.user_name, "{" + val + "}" if doc.question is "Participant Registration-es" or doc.question is "Participant Registration-es-DUPLICATE"