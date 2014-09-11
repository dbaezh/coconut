class RegSurveyReportViewOnlyCSV extends Backbone.View

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


        dataByUUID = []
        for idx of data.rows
          uuid = data.rows[idx].key
          dataByUUID[uuid] = data.rows[idx].value;


        _this.registrations = dataByUUID
        data= [];
        _this.complete = 'true'
        if _this.options.complete isnt undefined and _this.options.complete isnt 'true'
          _this.complete = 'false'


        # fetch results
        results.fetch
          "question" : _this.quid
          "complete" : _this.complete
          success: (allResults) ->
            _this.fields = getSurveyFields()
            #console.log allResults.first()
            #window.allResults = allResults

            _this.results = allResults.where(question: _this.quid)
            #fields = _.chain(_this.results).map((result) ->
            #  _.keys result.attributes
            #).flatten().uniq().value()

            #if @quid is "Participant Survey-es"
            #  _this.fields = _(fields).without("_id", "_rev", "test", "user", "question", "collection", "16Estasactualmenteasistiendoaunaescuelaouniversidad","16ACuáleselnombredetuescuelaouniversidad","16ACuáleselnombredetuescuelaouniversidad","20Enlosúltimos12meseshassidosuspendidoadelaescuela","17Estasactualmenteasistiendoaalgunodeestosprogramas","18Hasrepetidouncursoenlaescuela","18ACuálescursos","21ACuálescursos","23Hasidosuspendidoadelaescuela","24Conrespectoatueducaciónquétegustaríalograrenelfuturo","26Hasrealizadoalgunavezuntrabajoporpagaoganancia","27Durantelaúltimasemanarealizastealgúntrabajoporpagaoganancia","271Describeloquehaceseneltrabajoactual","28Cuándocomenzasteeneltrabajoactual","28Mes","28Año","29Enquélugarrealizasestetrabajo","29EnquélugarOtros","30Cuántashorastrabajasenundía","31Cuántosdíastrabajasenunasemana","32Enpromediocuántoganasenunasemana","33Enestetrabajotúeres","33OtroTúeres","34Actualmenterealizasalgúntrabajoenelquenosetepagaonorecibesganancia","34ADescribeloquehacesenestetrabajo","35Cuándocomenzasteatrabajarenestetrabajo","35Mes","35Año","36Enquélugarrealizasestetrabajo","36EnquélugarrealizasestetrabajoOtros","37Cuántashorastrabajasenundía","38Cuántosdíastrabajasenunasemana","39Enestetrabajotúeres","39EnestetrabajotúeresOtro","40Hasbuscadounnuevoomejorempleoenelúltimomes","","42Hasparticipadoenalgúnprogramadedesarrollodeempleo","43Conquéfrecuenciatepreocupaservíctimadeladelincuenciaentubarrio","44Conquéfrecuenciatepreocupaservíctimadeladelincuenciaentuescuelaouniversidad","45Enquémedidatuvidahasidoafectadaporladelincuencia","46Entuopiniónladelincuenciaesunproblemagraveentubarrio","47Tepreocupalapresenciadepandillasentubarrio","48Lapreocupaciónporladelincuenciaocrimenteimpiderealizarlascosasquedeseashacerentubarrio","49Hastenidoalgunavezunaovariasdelassiguientesexperienciasconlapolicía","49AUnpolicíameamenazóverbalmente","49BUnpolicíamecobródinerosinjustificación","49CUnpolicíatomóalgoquepertenecíaamí","49DUnpolicíamemaltratófísicamente","50Hassidotransportadoenunapatrullapolicialporunaredadaoporsospechadelapolicíahaciati","51Hassidodetenidoporlapolicíaporcualquiermotivo","51ASucedióestoenlosúltimos12meses","52HassidodetenidoporlaPolicíaacusadodecometeralgúndelito","52ASucedióestoenlosúltimos12meses","53AlgunodetusamigoshasidodetenidoalgunavezporlaPolicía","53ASucedióestoenlosúltimos12meses","54Enlosúltimos12meseshastomadoalgodeunatiendasinpagarporella","55Enlosúltimos12meseshasparticipadoenalgunapeleaoriña","56Enlosúltimos12meseshasllevadouncuchillopuñalomachete","56AEncuáleslugarespasó","57Enlosúltimos12meseshasllevadounarmadefuego","57ASilarespuestaesafirmativaencuáleslugarespasó","58Enlosúltimos12meseshasvistoaalguienqueestabasiendoapuñaladocortadoobaleado","58AEncuáleslugarespasó","59Enlosúltimos12mesesalguientehaamenazadoconuncuchilloounapistola","59AEncuáleslugarespasó","60Enlosúltimos12mesesalguientehacortadooapuñaladotangravementequetuvistequeiraunmédico","60ASilarespuestaesafirmativaencuáleslugarespasó","61Enlosúltimos12mesesalguientehadisparadoconunarmadefuego","61AEncuáleslugarespasó","62Enlosúltimos12meseshasamenazadoaalguienconcortarleapuñalarleodispararle","62AEncuáleslugarespasó","63Enlosúltimos12meseshasamenazadoaalguienconuncuchillooarma","63AEncuáleslugarespasó","64Enlosúltimos12meseshascortadooapuñaladoaalguien","64AEncuáleslugarespasó","65Enlosúltimos12meseslehasdisparadoaalguien","65AEncuáleslugarespasó","66Enlosúltimos12meseshastenidoalgúnamigoomiembrodetufamiliaquelehandisparadocortadooapuñalado","67Hasdañadoodestruidoapropósitoartículosquenotepertenecen","68Algunavezhassidoatacadoorobado","69Algunavezhasatacadoorobadoaalguien","70Algunavezhassidosecuestrado","71Algunavezhassecuestradoaalguien","72AlgunavezhasrobadoalgodeunatiendaoalgoquenotepertenecíaqueteníaunvalormenordeRD$200","73AlgunavezharobadoalgodeunatiendaoalgoquenotepertenecíaqueteníaunvalormayordeRD$200incluyendocarros","74Algunavezhasvendidooayudadoavenderdrogas","75Hasestadoinvolucradoenunapandilla","75AActualmenteestásinvolucradoenunapandilla","76Compartestiempooterelacionasconmiembrosdeunapandilla","76AEncuáleslugarespasó","77Enlosúltimos12meseshashabladoocompartidoconalguienborrachooqueestabadrogado","78Algunavezhastomadounabebidaalcohólica–unacopavasoenteronosólounsorbo","78AEnlosúltimos12meseshasconsumidoalcohol","78BEnlosúltimos12meseshastomadocincovasoscopasomásdebebidasalcohólicasenelmismodía","79Hasprobadoalgunavezcualquieradeestasdrogasmarihuanacocaínaheroínapastillascrackcementoocualquierotracosaparadrogarse","80Hasusadoenalgunaocasiónunaagujaparainyectartedroga","81Marcaelnombredelasdrogasquehayasprobadoenalgúnmomento","81AMarihuana","81BCrack","81CCocaínaenpolvo","81DHeroína","81EMetanfetaminaocristal","81FÉxtasisMDMA","81GInhalantescomopegamentocementopinturaspray","81HNoresponde","81IOtra","82Marcaelnombredelasdrogasquehayasprobadoenlosúltimos12meses","82AMarihuana","82BCrack","82CCocaínaenpolvo","82DHeroína","82EMetanfetaminaocristal","82FÉxtasisMDMA","82GInhalantescomopegamentocementopinturaspray","81HNoresponde","82IOtra","83Encasodequehayasprobadoalgunadrogaleecadanombreydinosquéedadteníaslaprimeravezquelaprobaste","83AMarihuana","83BCrack","83CCocaínaenpolvo","83DHeroína","83EMetanfetaminaocristal","83FÉxtasisMDMA","83GInhalantescomopegamentocementopinturaspray","83HOtraand83HOtradroga","84Algunavezhastenidorelacionessexuales","85Quéedadteníaslaprimeravezquetuvisterelacionessexuales","86Conquiéneshastenidorelacionessexuales","87Concuántaspersonasdiferenteshastenidorelacionessexualesenlosúltimos12meses","88Laúltimavezquetuvisterelacionessexualestuotucompañeroautilizóuncondón","89LaúltimavezquetuvisterelacionessexualescuálmétodousasteotucompañeroaparaprevenirelembarazoSeleccionesólounaopción","89Otro","90Algunavezalguientehaobligadoatenerrelacionessexuales","91Algunavezhastenidorelacionessexualespordinerobienescelularesviviendaetcoserviciosproteccióncomidaetc","91ASilarespuestaesafirmativaCuándofuelaúltimavez","92Siquisierascompraruncondóncreesquepodríasencontrarlo","93Siquisierastenersexocreesqueseríascapazdeconvenceratuparejaqueuseuncondónencasoqueélellanoquiera","94Tesientescapazdetenerunaconversaciónabiertayhonestasobresexoconsuspadres","95Algunavezhastenidounaconversaciónabiertayhonestasobresexocontuspadres","96AlgunaveztehanenseñadoacercadelasInfeccionesdetransmisiónsexual","96ADóndehasrecibidoinformacióndelasInfeccionesdeTransmisiónSexual","96AOtro","97Algunavezlehanenseñadoacercadeprevencióndeembarazo","97ADóndehasrecibidoinformacióndeprevencióndeembarazo","97AOtro","98AlgunavezlehanenseñadoacercalainfecciónporVIHSida","98ADóndehasrecibidoinformacióndeVIHSida","98AOtro","81AMarihuana","81BCrack","81CCocaínaenpolvo","81DHeroína","81EMetanfetaminaocristal","81FxtasisMDMA","81FÉxtasisMDMA","81GInhalantescomopegamentocementopinturaspray","81HNoresponde","81HOtraespecifica","81IOtra","81IOtradroga","82AMarihuana","82Algunavezhastenidorelacionessexuales","82BCrack","82CCocaínaenpolvo","82DHeroína","82EMetanfetaminaocristal","82FxtasisMDMA","82GInhalantescomopegamentocementopinturaspray","82IOtra","82IOtradroga","83AMarihuana","83BCrack","83CCocaínaenpolvo","83DHeroína","83EMetanfetaminaocristal","83FxtasisMDMA","83GInhalantescomopegamentocementopinturaspray","83HOtra","83HOtradroga","83Quéedadteníaslaprimeravezquetuvisterelacionessexuales","35Año","35EnquélugarrealizasestetrabajoOtros","35Mes","83AMarihuana","83BCrack","83CCocaínaenpolvo","83DHeroína","83EMetanfetaminaocristal","83FxtasisMDMA","83GInhalantescomopegamentocementopinturaspray","83HOtra","83HOtradroga","83Quéedadteníaslaprimeravezquetuvisterelacionessexuales");
            #else
            #  _this.fields = _(fields).without("_id", "_rev", "test", "user", "question", "collection")


            _this.render()

      error: (data) ->
        alert "Someting wrong"


  initialize: (options) ->
    urlParams = []
    @$el.append '<div id="reportloader"><marquee ALIGN="Top" LOOP="infinite"  DIRECTION="right" style="font-size:24px; color:#FF8000">Cargando el informe. Por favor espera ...</marquee></div>'
    this.options = options

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
    headersNum=0

    if @results is undefined
      return;
    for result in @results

      # filter by provider id
      if this['provider_id'] isnt undefined and result.get('provider_id') isnt this['provider_id']
        continue

    csvContent = "\uFEFF";
    csvContent += "Fecha de Registro,Nombre,Apellido,Apodo, Sexo,Fecha de Nacimiento, Calleynumero,Provincia,Municipio,BarrioComunidad,"

    i = 0

    while i < @fields.length
      jsonField = @fields[i]
      for key of jsonField
        if jsonField.hasOwnProperty(key)
          innerValue = key;
          resval = innerValue.replace(/"/g, '""');
          if (resval.search(/("|,|\n)/g) >= 0)
            resval = '"' + resval + '"';

          csvContent += resval + ','
      i++


    csvContent += "\n"

    for result in @results
      # filter by provider id
      if this['provider_id'] isnt undefined and result.get('provider_id') isnt this['provider_id']
        continue

      isRegExist = false
      uuid = result.get("uuid");
      if @registrations[uuid] isnt undefined
        isRegExist = true
        regvalues = @registrations[uuid].replace(/[//]/g, '')
        regvalues = @registrations[uuid].replace(/[//]/g, '')
        try
          regvals = jQuery.parseJSON(regvalues)
          csvContent += '"' + regvals.Fecha + '"' + ','
          csvContent += '"' + regvals.Nombre + '"' + ','
          csvContent += '"' + regvals.Apellido + '"' + ','
          csvContent += '"' + regvals.Apodo + '"' + ','
          csvContent += '"' + regvals.Sexo + '"' + ','
          birthday = regvals.Día + "/" + regvals.Mes + "/" + regvals.Año
          csvContent += '"' + birthday + '"' + ','
          csvContent += '"' + regvals.Calleynumero + '"' + ','
          csvContent += '"' + regvals.Provincia + '"' + ','
          csvContent += '"' + regvals.Municipio + '"' + ','
          csvContent += '"' + regvals.BarrioComunidad + '"' + ','
        catch e
          isRegExist = false


      if isRegExist is false
        continue



      isRegExist = false
      @searchRows[result.id] = ""

      i = 0

      while i < @fields.length
        jsonField = @fields[i]
        for key of jsonField
          if jsonField.hasOwnProperty(key)
            innerValue = "";
            field = jsonField[key]
            if result.get(field) is undefined or result.get(field) is null
              innerValue =  ''
            else
              innerValue = result.get(field).toString();

            resval = innerValue.replace(/"/g, '""');
            if (resval.search(/("|,|\n)/g) >= 0)
              resval = '"' + resval + '"';

            csvContent += resval + ','

        i++

      csvContent += "\n"

    a = document.createElement('a');
    blob = new Blob([csvContent], {'type':'text/csv;charset=utf-8'});
    a.href = window.URL.createObjectURL(blob);
    a.download = "report.csv";
    $('#reportloader').hide();
    a.click();
