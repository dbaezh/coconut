(doc) ->
  if doc.collection is "result" and doc.Completado

    hasRequiredFields = doc['Apellido']? and doc['Nombre']?  and doc['Municipio']? and doc['BarrioComunidad']? and doc['Sexo']?  and doc['Día']?  and doc['Mes']?  and doc['Año']?
    return unless hasRequiredFields

    spacePattern = new RegExp(" ", "g") 

    family    = (doc['Apellido']       || '').toLowerCase()
    names     = (doc['Nombre']         || '').toLowerCase()
    municipality = (doc['Municipio'] || '').toLowerCase()
    community = (doc['BarrioComunidad'] || '').toLowerCase()
    sexo      = (doc['Sexo']           || '').toLowerCase()
    dobDia = (doc['Día'] || '').toLowerCase()
    dobMes = (doc['Mes'] || '').toLowerCase()
    dobAno = (doc['Año'] || '').toLowerCase()

    key = [family, names, municipality, community, sexo, dobDia, dobMes, dobAno].join(":").replace(spacePattern, '')

    emit key, doc

