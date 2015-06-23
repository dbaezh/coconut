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

    dobDia = "0" + dobDia  if dobDia.length < 2

    dobMes = (doc['Mes'] || '').toLowerCase()

    mes = dobMes
    switch dobMes
      when "enero"
        mes = "01"
      when "febrero"
        mes = "02"
      when "marzo"
        mes = "03"
      when "abril"
        mes = "04"
      when "mayo"
        mes = "05"
      when "junio"
        mes = "06"
      when "julio"
        mes = "07"
      when "agosto"
        mes = "08"
      when "septiembre"
        mes = "09"
      when "octubre"
        mes = "10"
      when "noviembre"
        mes = "11"
      when "diciembre"
        mes = "12"

    mes = "0" + mes  if mes.length < 2

    dobAno = (doc['Año'] || '').toLowerCase()

    key = [family, names, municipality, community, sexo, dobDia, mes, dobAno].join(":").replace(spacePattern, '')

    emit key, doc

