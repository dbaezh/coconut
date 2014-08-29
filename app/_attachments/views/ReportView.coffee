class ReportView extends Backbone.View

  el: "#content"

  #events:
    #"keyup #search" : "filter"


  getCompletedDocsUUIDsAndFetch: ->

    results = undefined
    _this = this
    completedDocs = undefined
    results = new ResultCollection
    results.model = Result
    results.url = "result"
  
    # TBD: Don't fetch directly use a model and collection
    db = $.couch.db("coconut")
    db.view "coconut/byUUIDForReportActions",
      success: (data) ->
        _this.completedDocs = data
      
        # fetch results
        results.fetch
          "question" : _this.quid
          success: (allResults) ->
            fields = undefined
            console.log allResults.first()
            window.allResults = allResults
            console.log "trying to get all from"
            console.log _this.quid
            _this.results = allResults.where(question: _this.quid)
            fields = _.chain(_this.results).map((result) ->
              _.keys result.attributes
            ).flatten().uniq().value()
            if _this["isActions"] isnt undefined
              _this.fields = _(fields).without("_id", "_rev", "test", "user", "question", "collection", "createdAt", "lastModifiedAt", "Teléfono", "Calleynumero", "Día", "Mes", "Año", "Celular", "Casa", "Direccióndecorreoelectrónico", "NombredeusuariodeFacebook", "Nombredepersonadecontacto", "Parentescoopersonarelacionada", "Completado", "savedBy", "Sexo", "Tieneunnumerocelular", "Tieneunnumerodetelefonoenlacasa", "Tieneunadireccióndecorreoelectrónico", "TieneunnombredeusuariodeFacebook")
            else
              _this.fields = _(fields).without("_id", "_rev", "test", "user", "question", "collection")
            _this.render()

      error: (data) ->
        alert "Someting wrong"


  initialize: (options) ->
    urlParams = []
    @$el.append '<div id="reportloader"><marquee ALIGN="Top" LOOP="infinite"  DIRECTION="right" style="font-size:24px; color:#FF8000">Cargando el informe. Por favor espera ...</marquee></div>'

    for key of options
      value = options[key]
      this[key] = value
  
      # do not need startDate and endDate
      urlParams.push "" + key + "=" + value + ""  if key isnt "startDate" and key isnt "endDate"

    @urlParams = urlParams

    console.log @quid

    #results = new Backbone.Collection
    if this['quid'] is "Participant Survey-es"
      results = new ResultCollectionSurvey
    else
      results = new ResultCollection

    results.model = Result
    results.url = "result"


    if false
       _this.getCompletedDocsUUIDsAndFetch();
    else
      results.fetch
        "question" : @quid
        success: (allResults) =>
          console.log allResults.first()
          window.allResults = allResults
          console.log "trying to get all from"
          console.log @quid
          @results = allResults.where
            "question" : @quid

          fields = _.chain(@results)
              .map (result) ->
                _.keys(result.attributes)
              .flatten()
              .uniq()
              .value()




            if  this["isActions"] isnt undefined
              @fields = _(fields).without("_id", "_rev", "test", "user", "question", "collection", "createdAt", "Apodo","Estecolateralparticipante","lastModifiedAt", "Teléfono", "Calleynumero", "Día", "Mes", "Año", "Celular", "Casa", "Direccióndecorreoelectrónico", "NombredeusuariodeFacebook", "Nombredepersonadecontacto", "Parentescoopersonarelacionada", "Completado", "savedBy", "Sexo", "Tieneunnumerocelular", "Tieneunnumerodetelefonoenlacasa", "Tieneunadireccióndecorreoelectrónico", "TieneunnombredeusuariodeFacebook")
            else if @quid is "Participant Survey-es"
              @fields = _(fields).without("_id", "_rev", "test", "user", "question", "collection", "16Estasactualmenteasistiendoaunaescuelaouniversidad","16ACuáleselnombredetuescuelaouniversidad","16ACuáleselnombredetuescuelaouniversidad","20Enlosúltimos12meseshassidosuspendidoadelaescuela","17Estasactualmenteasistiendoaalgunodeestosprogramas","18Hasrepetidouncursoenlaescuela","18ACuálescursos","21ACuálescursos","23Hasidosuspendidoadelaescuela","24Conrespectoatueducaciónquétegustaríalograrenelfuturo","26Hasrealizadoalgunavezuntrabajoporpagaoganancia","27Durantelaúltimasemanarealizastealgúntrabajoporpagaoganancia","271Describeloquehaceseneltrabajoactual","28Cuándocomenzasteeneltrabajoactual","28Mes","28Año","29Enquélugarrealizasestetrabajo","29EnquélugarOtros","30Cuántashorastrabajasenundía","31Cuántosdíastrabajasenunasemana","32Enpromediocuántoganasenunasemana","33Enestetrabajotúeres","33OtroTúeres","34Actualmenterealizasalgúntrabajoenelquenosetepagaonorecibesganancia","34ADescribeloquehacesenestetrabajo","35Cuándocomenzasteatrabajarenestetrabajo","35Mes","35Año","36Enquélugarrealizasestetrabajo","36EnquélugarrealizasestetrabajoOtros","37Cuántashorastrabajasenundía","38Cuántosdíastrabajasenunasemana","39Enestetrabajotúeres","39EnestetrabajotúeresOtro","40Hasbuscadounnuevoomejorempleoenelúltimomes","","42Hasparticipadoenalgúnprogramadedesarrollodeempleo","43Conquéfrecuenciatepreocupaservíctimadeladelincuenciaentubarrio","44Conquéfrecuenciatepreocupaservíctimadeladelincuenciaentuescuelaouniversidad","45Enquémedidatuvidahasidoafectadaporladelincuencia","46Entuopiniónladelincuenciaesunproblemagraveentubarrio","47Tepreocupalapresenciadepandillasentubarrio","48Lapreocupaciónporladelincuenciaocrimenteimpiderealizarlascosasquedeseashacerentubarrio","49Hastenidoalgunavezunaovariasdelassiguientesexperienciasconlapolicía","49AUnpolicíameamenazóverbalmente","49BUnpolicíamecobródinerosinjustificación","49CUnpolicíatomóalgoquepertenecíaamí","49DUnpolicíamemaltratófísicamente","50Hassidotransportadoenunapatrullapolicialporunaredadaoporsospechadelapolicíahaciati","51Hassidodetenidoporlapolicíaporcualquiermotivo","51ASucedióestoenlosúltimos12meses","52HassidodetenidoporlaPolicíaacusadodecometeralgúndelito","52ASucedióestoenlosúltimos12meses","53AlgunodetusamigoshasidodetenidoalgunavezporlaPolicía","53ASucedióestoenlosúltimos12meses","54Enlosúltimos12meseshastomadoalgodeunatiendasinpagarporella","55Enlosúltimos12meseshasparticipadoenalgunapeleaoriña","56Enlosúltimos12meseshasllevadouncuchillopuñalomachete","56AEncuáleslugarespasó","57Enlosúltimos12meseshasllevadounarmadefuego","57ASilarespuestaesafirmativaencuáleslugarespasó","58Enlosúltimos12meseshasvistoaalguienqueestabasiendoapuñaladocortadoobaleado","58AEncuáleslugarespasó","59Enlosúltimos12mesesalguientehaamenazadoconuncuchilloounapistola","59AEncuáleslugarespasó","60Enlosúltimos12mesesalguientehacortadooapuñaladotangravementequetuvistequeiraunmédico","60ASilarespuestaesafirmativaencuáleslugarespasó","61Enlosúltimos12mesesalguientehadisparadoconunarmadefuego","61AEncuáleslugarespasó","62Enlosúltimos12meseshasamenazadoaalguienconcortarleapuñalarleodispararle","62AEncuáleslugarespasó","63Enlosúltimos12meseshasamenazadoaalguienconuncuchillooarma","63AEncuáleslugarespasó","64Enlosúltimos12meseshascortadooapuñaladoaalguien","64AEncuáleslugarespasó","65Enlosúltimos12meseslehasdisparadoaalguien","65AEncuáleslugarespasó","66Enlosúltimos12meseshastenidoalgúnamigoomiembrodetufamiliaquelehandisparadocortadooapuñalado","67Hasdañadoodestruidoapropósitoartículosquenotepertenecen","68Algunavezhassidoatacadoorobado","69Algunavezhasatacadoorobadoaalguien","70Algunavezhassidosecuestrado","71Algunavezhassecuestradoaalguien","72AlgunavezhasrobadoalgodeunatiendaoalgoquenotepertenecíaqueteníaunvalormenordeRD$200","73AlgunavezharobadoalgodeunatiendaoalgoquenotepertenecíaqueteníaunvalormayordeRD$200incluyendocarros","74Algunavezhasvendidooayudadoavenderdrogas","75Hasestadoinvolucradoenunapandilla","75AActualmenteestásinvolucradoenunapandilla","76Compartestiempooterelacionasconmiembrosdeunapandilla","76AEncuáleslugarespasó","77Enlosúltimos12meseshashabladoocompartidoconalguienborrachooqueestabadrogado","78Algunavezhastomadounabebidaalcohólica–unacopavasoenteronosólounsorbo","78AEnlosúltimos12meseshasconsumidoalcohol","78BEnlosúltimos12meseshastomadocincovasoscopasomásdebebidasalcohólicasenelmismodía","79Hasprobadoalgunavezcualquieradeestasdrogasmarihuanacocaínaheroínapastillascrackcementoocualquierotracosaparadrogarse","80Hasusadoenalgunaocasiónunaagujaparainyectartedroga","81Marcaelnombredelasdrogasquehayasprobadoenalgúnmomento","81AMarihuana","81BCrack","81CCocaínaenpolvo","81DHeroína","81EMetanfetaminaocristal","81FÉxtasisMDMA","81GInhalantescomopegamentocementopinturaspray","81HNoresponde","81IOtra","82Marcaelnombredelasdrogasquehayasprobadoenlosúltimos12meses","82AMarihuana","82BCrack","82CCocaínaenpolvo","82DHeroína","82EMetanfetaminaocristal","82FÉxtasisMDMA","82GInhalantescomopegamentocementopinturaspray","81HNoresponde","82IOtra","83Encasodequehayasprobadoalgunadrogaleecadanombreydinosquéedadteníaslaprimeravezquelaprobaste","83AMarihuana","83BCrack","83CCocaínaenpolvo","83DHeroína","83EMetanfetaminaocristal","83FÉxtasisMDMA","83GInhalantescomopegamentocementopinturaspray","83HOtraand83HOtradroga","84Algunavezhastenidorelacionessexuales","85Quéedadteníaslaprimeravezquetuvisterelacionessexuales","86Conquiéneshastenidorelacionessexuales","87Concuántaspersonasdiferenteshastenidorelacionessexualesenlosúltimos12meses","88Laúltimavezquetuvisterelacionessexualestuotucompañeroautilizóuncondón","89LaúltimavezquetuvisterelacionessexualescuálmétodousasteotucompañeroaparaprevenirelembarazoSeleccionesólounaopción","89Otro","90Algunavezalguientehaobligadoatenerrelacionessexuales","91Algunavezhastenidorelacionessexualespordinerobienescelularesviviendaetcoserviciosproteccióncomidaetc","91ASilarespuestaesafirmativaCuándofuelaúltimavez","92Siquisierascompraruncondóncreesquepodríasencontrarlo","93Siquisierastenersexocreesqueseríascapazdeconvenceratuparejaqueuseuncondónencasoqueélellanoquiera","94Tesientescapazdetenerunaconversaciónabiertayhonestasobresexoconsuspadres","95Algunavezhastenidounaconversaciónabiertayhonestasobresexocontuspadres","96AlgunaveztehanenseñadoacercadelasInfeccionesdetransmisiónsexual","96ADóndehasrecibidoinformacióndelasInfeccionesdeTransmisiónSexual","96AOtro","97Algunavezlehanenseñadoacercadeprevencióndeembarazo","97ADóndehasrecibidoinformacióndeprevencióndeembarazo","97AOtro","98AlgunavezlehanenseñadoacercalainfecciónporVIHSida","98ADóndehasrecibidoinformacióndeVIHSida","98AOtro","81AMarihuana","81BCrack","81CCocaínaenpolvo","81DHeroína","81EMetanfetaminaocristal","81FxtasisMDMA","81FÉxtasisMDMA","81GInhalantescomopegamentocementopinturaspray","81HNoresponde","81HOtraespecifica","81IOtra","81IOtradroga","82AMarihuana","82Algunavezhastenidorelacionessexuales","82BCrack","82CCocaínaenpolvo","82DHeroína","82EMetanfetaminaocristal","82FxtasisMDMA","82GInhalantescomopegamentocementopinturaspray","82IOtra","82IOtradroga","83AMarihuana","83BCrack","83CCocaínaenpolvo","83DHeroína","83EMetanfetaminaocristal","83FxtasisMDMA","83GInhalantescomopegamentocementopinturaspray","83HOtra","83HOtradroga","83Quéedadteníaslaprimeravezquetuvisterelacionessexuales","35Año","35EnquélugarrealizasestetrabajoOtros","35Mes","83AMarihuana","83BCrack","83CCocaínaenpolvo","83DHeroína","83EMetanfetaminaocristal","83FxtasisMDMA","83GInhalantescomopegamentocementopinturaspray","83HOtra","83HOtradroga","83Quéedadteníaslaprimeravezquetuvisterelacionessexuales");
            else
              @fields = _(fields).without("_id", "_rev", "test", "user", "question", "collection")

          @render()

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

    if @results is undefined
      return;
    for result in @results
      
      # filter by provider id
      if this['provider_id'] isnt undefined and result.get('provider_id') isnt this['provider_id']
          continue
       
      total++;


    html = "<div style='overflow:auto;' ><table id='reportTable'>
      <thead>
        <tr>"
    for field in @fields
      if this['isActions'] isnt undefined
        html += "<th>" + field + "</th>"  if field isnt "user_name" and field isnt "provider_id" and field isnt "provider_name"
      else
        html += "<th>" + field + "</th>"

      headers[_j] = field

    html += "<th>Acción</th>"  if this["isActions"] isnt undefined
    html += "</tr></thead>
    <tbody>"


    for result in @results
      

      # filter by provider id
      if this['provider_id'] isnt undefined and result.get('provider_id') isnt this['provider_id']
        continue

      html += "<tr class='row-#{result.id}'>"
      @searchRows[result.id] = ""
      for field in @fields
        if this["isActions"] isnt undefined and (field is "user_name" or field is "provider_id" or field is "provider_name")
          continue
        else
          html += "<td>" + (result.get(field)) + "</td>"
          @searchRows[result.id] += result.get(field)

      
       #prepare parameters for the actions
       if this["isActions"] isnt undefined
         isSurveyExist = false
         isExitExist = false
         @urlParams.push "uuid=" + result.get("uuid")
         sPassed = "/" + @urlParams.join("&")

         html += "<td>"
         unless isSurveyExist
           html += "<a href=\"#new/result/Participant Survey-es" + sPassed + "\">Una Nueva Encuesta</a><br>"

         unless isExitExist
           html += "<a href=\"#new/result/Exit Survey-es" + sPassed + "\">Salida</a><br>"

         html += "<a href=\"#view/result/" + result.id +  sPassed + "\">Ver Registro</a></td>"

         @urlParams.removeByValue "uuid=" + result.get("uuid")

       html += "</tr>"

    html += "</tbody></table></div>"

    @$el.html html

    $('#reportTable').dataTable({
      "bPaginate": true,
      "bSort": true,
      "bFilter": true
    });

    $('#reportloader').hide();

    # download to csv file and make rows display in different colors
    #$("table").each ->
    #   $table = $(this)
    #   data = $table.table2CSV(
    #    delivery: "value"
    #    header: headers
    #   )

    #   blob = new Blob([data],type: "application/octet-binary")
    #   url = URL.createObjectURL(blob)

    #   $("<a><font size=\"2px\">Exportar a CSV</font></a>").attr("id", "downloadFile").attr({href: url}).attr("download", "report.csv").insertBefore $table

    #   if this['quid'] isnt "Participant Survey-es"
    #      $('table tr').each (index, row) ->
    #        $(row).addClass("odd") if index % 2 is 1


class OldReportView extends Backbone.View
  initialize: (options) ->


    @quid = options.quid


    $("html").append "
      <link href='js-libraries/Leaflet/leaflet.css' type='text/css' rel='stylesheet' />
      <script type='text/javascript' src='js-libraries/Leaflet/leaflet.js'></script>
      <style>
        .dissaggregatedResults{
          display: none;
        }
      </style>
    "

  el: '#content'

  events:
    "change #reportOptions": "update"
    "change #summaryField": "summarize"
    "click #toggleDisaggregation": "toggleDisaggregation"

  update: =>
    reportOptions =
      startDate: $('#start').val()
      endDate: $('#end').val()
      reportType: $('#report-type :selected').text()

    _.each @locationTypes, (location) ->
      reportOptions[location] = $("##{location} :selected").text()

    url = "reports/" + _.map(reportOptions, (value, key) ->
      "#{key}/#{escape(value)}"
    ).join("/")

    Coconut.router.navigate(url,true)

  render: (options) =>

    @reportType = options.reportType || "results"
    @startDate  = options.startDate  || moment(new Date).subtract('days',30).format("YYYY-MM-DD")
    @endDate    = options.endDate    || moment(new Date).format("YYYY-MM-DD")

    Coconut.questions.fetch
      success: =>

      @$el.html "
        <style>
          table.results th.header, table.results td{
            font-size:150%;
          }

        </style>

        <table id='reportOptions'></table>
        "

        $("#reportOptions").append @formFilterTemplate(
          id: "question"
          label: "Question"
          form: "
              <select id='selected-question'>
                #{
                  Coconut.questions.map( (question) ->
                    "<option>#{question.label()}</option>"
                  ).join("")
                }
              </select>
            "
        )

      $("#reportOptions").append @formFilterTemplate(
        id: "start"
        label: "Start Date"
        form: "<input id='start' type='date' value='#{@startDate}'/>"
      )

      $("#reportOptions").append @formFilterTemplate(
        id: "end"
        label: "End Date"
        form: "<input id='end' type='date' value='#{@endDate}'/>"
      )


      $("#reportOptions").append @formFilterTemplate(
        id: "report-type"
        label: "Report Type"
        form: "
        <select id='report-type'>
          #{
            _.map(["spreadsheet","results","summarytables"], (type) =>
              "<option #{"selected='true'" if type is @reportType}>#{type}</option>"
            ).join("")
          }
        </select>
        "
      )

      @[@reportType]()

      $('div[data-role=fieldcontain]').fieldcontain()
      $('select').selectmenu()
      $('input[type=date]').datebox {mode: "calbox"}


  hierarchyOptions: (locationType, location) ->
    if locationType is "region"
      return _.keys WardHierarchy.hierarchy
    _.chain(WardHierarchy.hierarchy)
      .map (value,key) ->
        if locationType is "district" and location is key
          return _.keys value
        _.map value, (value,key) ->
          if locationType is "constituan" and location is key
            return _.keys value
          _.map value, (value,key) ->
            if locationType is "shehia" and location is key
              return value
      .flatten()
      .compact()
      .value()

  mostSpecificLocationSelected: ->
    mostSpecificLocationType = "region"
    mostSpecificLocationValue = "ALL"
    _.each @locationTypes, (locationType) ->
      unless this[locationType] is "ALL"
        mostSpecificLocationType = locationType
        mostSpecificLocationValue = this[locationType]
    return {
      type: mostSpecificLocationType
      name: mostSpecificLocationValue
    }

  formFilterTemplate: (options) ->
    "
        <tr>
          <td>
            <label style='display:inline' for='#{options.id}'>#{options.label}</label> 
          </td>
          <td style='width:150%'>
            #{options.form}
            </select>
          </td>
        </tr>
    "

  viewQuery: (options) =>

    results = new ResultCollection()
    results.fetch
      question: @quid
      isComplete: true
      include_docs: true
      success: ->
        results.fields = {}
        results.each (result) ->
          _.each _.keys(result.attributes), (key) ->
            results.fields[key] = true unless _.contains ["_id","_rev","question"], key
        results.fields = _.keys(results.fields)
        options.success(results)

  results: ->
    @$el.append  "
      <table id='results' class='tablesorter'>
        <thead>
          <tr>
          </tr>
        </thead>
        <tbody>
        </tbody>
      </table>
    "

    @viewQuery
      success: (results) =>
        window.theseResults = results

        tableData = results.map (result) ->
          _.map results.fields, (field) ->
            result.get field

        $("table#results thead tr").append "
          #{ _.map(results.fields, (field) ->
            "<th>#{field}</th>"
          ).join("")
          }
        "

        $("table#results tbody").append _.map(tableData, (row) ->  "
          <tr>
            #{_.map(row, (element,index) -> "
              <td>#{element}</td>
            ").join("")
            }
          </tr>
        ").join("")

        _.each $('table tr'), (row, index) ->
          $(row).addClass("odd") if index%2 is 1

  spreadsheet: =>
    @viewQuery
      success: (results) =>
        console.log results

        csvData = results.map( (result) ->
          _.map(results.fields, (field) ->
            result.get field
          ).join ","
        ).join "\n"

        @$el.append "
          <a id='csv' href='data:text/octet-stream;base64,#{Base64.encode(results.fields.join(",") + "\n" + csvData)}' download='#{@startDate+"-"+@endDate}.csv'>Download spreadsheet</a>
        "
        $("a#csv").button()

  summarytables: ->
    Coconut.resultCollection.fetch
      includeData: true
      success: =>

        fields = _.chain(Coconut.resultCollection.toJSON())
        .map (result) ->
          _.keys(result)
        .flatten()
        .uniq()
        .sort()
        .value()

        fields = _(fields).without("_id", "_rev")
    
        @$el.append  "
          <br/>
          Choose a field to summarize:<br/>
          <select id='summaryField'>
            #{
              _.map(fields, (field) ->
                "<option id='#{field}'>#{field}</option>"
              ).join("")
            }
          </select>
        "
        $('select').selectmenu()


  summarize: ->
    field = $('#summaryField option:selected').text()

    @viewQuery
      success: (resultCollection) =>

        results = {}

        resultCollection.each (result) ->
          _.each result.toJSON(), (value,key) ->
            if key is field
              if results[value]?
                results[value]["sums"] += 1
                results[value]["resultIDs"].push result.get "_id"
              else
                results[value] = {}
                results[value]["sums"] = 1
                results[value]["resultIDs"] = []
                results[value]["resultIDs"].push result.get "_id"

        @$el.append  "
          <h2>#{field}</h2>
          <table id='summaryTable' class='tablesorter'>
            <thead>
              <tr>
                <th>Value</th>
                <th>Total</th>
              </tr>
            </thead>
            <tbody>
              #{
                _.map( results, (aggregates,value) ->
                  "
                  <tr>
                    <td>#{value}</td>
                    <td>
                      <button id='toggleDisaggregation'>#{aggregates["sums"]}</button>
                    </td>
                    <td class='dissaggregatedResults'>
                      #{
                        _.map(aggregates["resultIDs"], (resultID) ->
                          resultID
                        ).join(", ")
                      }
                    </td>
                  </tr>
                  "
                ).join("")
              }
            </tbody>
          </table>
        "
        $("button").button()
        $("a").button()
        _.each $('table tr'), (row, index) ->
          $(row).addClass("odd") if index%2 is 1


  toggleDisaggregation: ->
    $(".dissaggregatedResults").toggle()

#  locations: ->
#    @$el.append "
#      <div id='map' style='width:100%; height:600px;'></div>
#    "
#
#    @viewQuery
#      # TODO use Cases, map notificatoin location too
#      success: (results) =>
#
#        locations = _.compact(_.map results, (caseResult) ->
#          if caseResult.Household?["HouseholdLocation-latitude"]
#            return {
#              MalariaCaseID: caseResult.caseId
#              latitude: caseResult.Household?["HouseholdLocation-latitude"]
#              longitude: caseResult.Household?["HouseholdLocation-longitude"]
#            }
#        )
#
#        if locations.length is 0
#          $("#map").html "
#            <h2>No location information for the range specified.</h2>
#          "
#          return
#
#        map = new L.Map('map', {
#          center: new L.LatLng(
#            locations[0]?.latitude,
#            locations[0]?.longitude
#          )
#          zoom: 9
#        })
#
#        map.addLayer(
#          new L.TileLayer(
#            'http://{s}.tile.cloudmade.com/4eb20961f7db4d93b9280e8df9b33d3f/997/256/{z}/{x}/{y}.png',
#            {maxZoom: 18}
#          )
#        )
#
#        _.each locations, (location) =>
#          map.addLayer(
#            new L.CircleMarker(
#              new L.LatLng(location.latitude, location.longitude)
#            )
#          )
