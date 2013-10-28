(doc) ->
  if doc.collection is "result" and doc.Completado

    hasRequiredFields = doc['Apellido']? and doc['Nombre']? and doc['BarrioComunidad']? and doc['Sexo']?
    return unless hasRequiredFields

    spacePattern = new RegExp(" ", "g") 

    family    = (doc['Apellido']       || '').toLowerCase()
    names     = (doc['Nombre']         || '').toLowerCase()
    community = (doc['BarrioComunidad'] || '').toLowerCase()
    sexo      = (doc['Sexo']           || '').toLowerCase()

    key = [family, names, community, sexo].join(":").replace(spacePattern, '')

    emit key, doc

