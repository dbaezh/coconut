class RegSurveyReportView extends Backbone.View

  el: "#content"

  events:
    "keyup #search" : "filter"


  getRegistrationsAndFetch: ->

    results = undefined
    _this = this
    registrations = undefined
    results = new ResultCollection
    results.model = Result
    results.url = "result"

    # TBD: Don't fetch directly use a model and collection
    db = $.couch.db("coconut")
    db.view "coconut/byUUIDRegistration",
      success: (data) ->
        _this.registrations = data

        # fetch results
        results.fetch
          "question" : _this.quid
          success: (allResults) ->
            fields = undefined
            console.log allResults.first()
            window.allResults = allResults

            _this.results = allResults.where(question: _this.quid)
            fields = _.chain(_this.results).map((result) ->
              _.keys result.attributes
            ).flatten().uniq().value()

            _this.fields = _(fields).without("_id", "_rev", "quid","reportType","test", "user", "question", "collection", "user_name", "isActions", "lastModifiedAt", "provider_id")

            _this.render()

      error: (data) ->
        alert "Someting wrong"


  initialize: (options) ->
    urlParams = []

    for key of options
      value = options[key]
      this[key] = value

      # do not need startDate and endDate
      urlParams.push "" + key + "=" + value + ""  if key isnt "startDate" and key isnt "endDate"

    @urlParams = urlParams
    this.getRegistrationsAndFetch();








  filter: (event) ->
    query = @$el.find("#search").val()
    for id, row of @searchRows
      if ~row.indexOf(query) or query.length < 3
        @$el.find(".row-#{id}").show()
      else
        @$el.find(".row-#{id}").hide()





  render: ->

    @searchRows = {}

    total =0
    headers = []
    regvals = null
    isRegExist = false

    if @results is undefined
      return;
    for result in @results

      # filter by provider id
      if this['provider_id'] isnt undefined and result.get('provider_id') isnt this['provider_id']
        continue

      total++;




    html = "<div style='font-size: 10pt'><input type='text' id='search' placeholder='filter'>&nbsp;&nbsp;<b>Entradas totales: " + total + "</b></div><br>";
    html += "<div style='overflow:auto;'><table class='tablesorter'>
          <thead>
            <tr>"

    html += "<th>Fecha</th><th>Nombre</th><th>Apellido</th><th>Apodo</th><th>Calleynumero</th><th>Provincia</th><th>Municipio</th><th>BarrioComunidad</th>"
    for field in @fields
      html += "<th>" + field + "</th>"

      headers[_j] = field


    html += "</tr></thead>
        <tbody>"


    for result in @results


      # filter by provider id
      if this['provider_id'] isnt undefined and result.get('provider_id') isnt this['provider_id']
        continue

      html += "<tr class='row-#{result.id}'>"

      #retrieve registration data
      for i of @registrations.rows
        if result.get("uuid") is @registrations.rows[i].key
          regvalues = @registrations.rows[i].value.replace(/[//]/g, '')
          regvalues = @registrations.rows[i].value.replace(/[//]/g, '')
          isRegExist = true
          try
            regvals = jQuery.parseJSON(regvalues)
            html += "<td>" + regvals.Fecha + "</td>"
            html += "<td>" + regvals.Nombre + "</td>"
            html += "<td>" + regvals.Apellido + "</td>"
            html += "<td>" + regvals.Apodo + "</td>"
            html += "<td>" + regvals.Calleynumero + "</td>"
            html += "<td>" + regvals.Provincia + "</td>"
            html += "<td>" + regvals.Municipio + "</td>"
            html += "<td>" + regvals.BarrioComunidad + "</td>"
            break
          catch e
            isRegExist = false
            break
      if isRegExist is false
        html += "</tr>"
        continue



      isRegExist = false
      @searchRows[result.id] = ""
      for field in @fields
        html += "<td>" + (result.get(field)) + "</td>"
        @searchRows[result.id] += result.get(field)


      html += "</tr>"

    "</tbody></table></div>"

    @$el.html html

    # download to csv file and make rows display in different colors
    $("table").each ->
      $table = $(this)
      data = $table.table2CSV(
        delivery: "value"
        header: headers
      )

      blob = new Blob([data],type: "application/octet-binary")
      url = URL.createObjectURL(blob)

      $("<a><font size=\"2px\">Exportar a CSV</font></a>").attr("id", "downloadFile").attr({href: url}).attr("download", "report.csv").insertBefore $table

      $('table tr').each (index, row) ->
        $(row).addClass("odd") if index % 2 is 1
