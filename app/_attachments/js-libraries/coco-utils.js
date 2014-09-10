/**
 * Created by vbakalov on 1/25/14.
 */

Object.defineProperty(Array.prototype, "removeByIndex", {
    enumerable: false,
    value: function (item) {
        var removeCounter = 0;

        for (var index = 0; index < this.length; index++) {
            if (this[index] === item) {
                this.splice(index, 1);
                removeCounter++;
                index--;
            }
        }

        return removeCounter;
    }
});

Array.prototype.removeByValue = function() {
    var what, a = arguments, L = a.length, ax;
    while (L && this.length) {
        what = a[--L];
        while ((ax = this.indexOf(what)) !== -1) {
            this.splice(ax, 1);
        }
    }
    return this;
};

/**
 * Saves the document as inactive and also incomplete so it does not show up in any results.
 * 
 *
 * @param result_id - the document id that will be marked as inactive and incomplete
 * @returns {*}
 */
function invalideDocById(result_id){
    Coconut.questionView.result = new Result({
        _id: result_id
    });

    // make inactive the registration
    return Coconut.questionView.result.fetch({
        success: function(model) {
            model.set({inactive:"true"});
            model.set({Completado:"false"});

           return  model.save(null, {success: function(){
                console.log("Successfully inactivated!");

            }});
        }});

}

function sortJSONData(data, key, asc) {
	return data.sort(function(a, b) {
		var x = a.value[key];
		var y = b.value[key];
		if (asc) return (x > y) ? 1 : ((x < y) ? -1 : 0);
		else     return (y > x) ? 1 : ((y < x) ? -1 : 0);
	});
}

// assumes you are sorting strings
function caseInsensitiveSortJSONData(data, key, asc) {
	return data.sort(function(a, b) {
		var x1 = a.value[key];
		var y1 = b.value[key];
		if (x1 == null || y1 == null) {
		  if (asc) {
			return 1;
		  } else {
			return -1;
		  }
		}
		var x = x1.toUpperCase();
		var y = y1.toUpperCase();
		if (asc) return (x > y) ? 1 : ((x < y) ? -1 : 0);
		else     return (y > x) ? 1 : ((y < x) ? -1 : 0);
	});
}

// Add startsWith function
if (typeof String.prototype.startsWith != 'function') {
    // see below for better implementation!
    String.prototype.startsWith = function (str){
        return this.indexOf(str) == 0;
    };
}


/**
 * Returns JSON object for the survey fields.
 * Hard-code survey fields so they show up the way they go in the survey and
 * not show questions from the old structure.
 *
 */
function getSurveyFields(){
  var surveyFields = [
      {"uuid": "uuid"},
{"provider_id": "provider_id"},
{"provider_name": "provider_name"},
{"createdAt": "createdAt"},
{"lastModifiedAt": "lastModifiedAt"},
{"Fecha": "Fecha"},
{"9": "9Dóndenaciste"},
{"9Dóndenacisteotro": "9Dóndenacisteotro"},
{"10": "10Tienesunactadenacimientodominicana"},
{"11": "11Cuálestuidiomaprincipal"},
{"11IdiomaprincipalOtro": "11IdiomaprincipalOtro"},
{"12": "12Cuálestuestadocivil"},
{"13": "13Tieneshijos"},
{"Fechadenacimiento": "Fechadenacimiento"},
{"Sexo": "Sexo"},
{"Ustedyellaniñoaviveenlamismacasa": "Ustedyellaniñoaviveenlamismacasa"},
{"Esteniñotieneunactadenacimientodominicana": "Esteniñotieneunactadenacimientodominicana"},
{"14": "14Sabesleeryescribir"},
{"15": "15Cuáleselniveleducativomásaltoquehasaprobado"},
{"16": "16Actualmenteestasasistiendoa"},
{"16ACuáleselnombredetuescuela": "16ACuáleselnombredetuescuela"},
{"16ACuáleselnombredetuuniversidad": "16ACuáleselnombredetuuniversidad"},
{"16BQuégradoestascursandoactualmente": "16BQuégradoestascursandoactualmente"},
{"16B1Cuálnivel": "16B1Cuálnivel"},
{"16CEnquétandaasistes": "16CEnquétandaasistes"},
{"16CCuálnivel": "16CCuálnivel"},
{"16DAquétandaasistes": "16DAquétandaasistes"},
{"17": "17Enelúltimoañocuántasveceshasfaltadoalaescuelaporundíacompletosinexcusa"},
{"18": "18Enlosúltimos12meseshassidosuspendidoadelaescuela"},
{"19": "19ActualmenteestasasistiendoaalgúnprogramadeeducaciónparajóvenesyadultosMarcalaopciónqueaplique"},
{"20": "20Hasrepetidoalgúncursoenlaescuela"},
{"20A": "20ASilarespuestaesafirmativacuálescursos"},
{"21": "21Hascompletadoalgúncursotécnico"},
{"21A": "21ASilarespuestaesafirmativacuálescursos"},
{"22": "22Actualmentetededicasa"},
{"23": "23Hassidosuspendidoadelaescuelaalgunavez"},
{"24Megustaríaleermejor": "Megustaríaleermejor"},
{"24Megustaríamejorarenmatemáticas": "Megustaríamejorarenmatemáticas"},
{"24Megustaríamejorarenciencias": "Megustaríamejorarenciencias"},
{"24Megustaríaestarenlaescuela": "Megustaríaestarenlaescuela"},
{"24Megustaríahablarmejorelespañol": "Megustaríahablarmejorelespañol"},
{"24Megustaríahablarelinglés": "Megustaríahablarelinglés"},
{"24Megustaríasabermásacercadeempleos": "Megustaríasabermásacercadeempleos"},
{"24Megustaríaterminarlabásica": "Megustaríaterminarlabásica"},
{"24Megustaríaterminarelbachillerato": "Megustaríaterminarelbachillerato"},
{"24MegustaríairalaUniversidad": "MegustaríairalaUniversidad"},
{"24Megustaríallevarmemejorconmismaestros": "Megustaríallevarmemejorconmismaestros"},
{"24Megustaríasentirmemásseguroenlaescuela": "Megustaríasentirmemásseguroenlaescuela"},
{"24Megustaríamejorarmiscalificaciones": "Megustaríamejorarmiscalificaciones"},
{"24Notengoningunameta": "Notengoningunameta"},
{"24Otrasmetas": "Otrasmetas"},
{"25": "25Hasrealizadoalgunavezuntrabajoporpagaoganancia"},
{"26": "26Durantelaúltimasemanarealizastealgúntrabajoporpagaoganancia"},
{"26A": "26ADescribeloquehaceseneltrabajoactual"},
{"27Mes": "27Mes"},
{"27Año": "27Año"},
{"28": "28Enquélugarrealizasestetrabajo"},
{"28EnquélugarOtros": "28EnquélugarOtros"},
{"29": "29Cuántashorastrabajasenundía"},
{"30": "30Cuántosdíastrabajasenunasemana"},
{"31": "31Enpromediocuántoganasenunasemana"},
{"32": "32Enestetrabajotúeres"},
{"32OtroTúeres": "32OtroTúeres"},
{"33": "33Actualmenterealizasalgúntrabajoenelquenosetepagaonorecibesganancia"},
{"33A": "33ADescribeloquehacesenestetrabajo"},
{"34Mes": "34Mes"},
{"34Año": "34Año"},
{"35": "35Enquélugarrealizasestetrabajo"},
{"35EnquélugarrealizasestetrabajoOtros": "35EnquélugarrealizasestetrabajoOtros"},
{"36": "36Cuántashorastrabajasenundía"},
{"37": "37Cuántosdíastrabajasenunasemana"},
{"38": "38Enestetrabajotúeres"},
{"38EnestetrabajotúeresOtro": "38EnestetrabajotúeresOtro"},
{"39": "39Hasbuscadounnuevoomejorempleoenelúltimomes"},
{"40": "40Hasparticipadoenalgúnprogramadedesarrollodeempleo"},
{"41": "41Conquéfrecuenciatepreocupaservíctimadeladelincuenciaentubarrio"},
{"42": "42Conquéfrecuenciatepreocupaservíctimadeladelincuenciaentuescuelaouniversidad"},
{"43": "43Enquémedidatuvidahasidoafectadaporladelincuencia"},
{"44": "44Entuopiniónladelincuenciaesunproblemagraveentubarrio"},
{"45": "45Tepreocupalapresenciadepandillasentubarrio"},
{"46": "46Lapreocupaciónporladelincuenciaocrimenteimpiderealizarlascosasquedeseashacerentubarrio"},
{"47A": "47AUnpolicíameamenazóverbalmente"},
{"47B": "47BUnpolicíamecobródinerosinjustificación"},
{"47C": "47CUnpolicíamequitóalgoquemepertenecia"},
{"47D": "47DUnpolicíamemaltratófísicamente"},
{"48": "48Hassidotransportadoenunapatrullapolicialporunaredadaoporsospechadelapolicíahaciati"},
{"49": "49Hassidodetenidoporlapolicíaporalgúnmotivo"},
{"49A": "49ASucedióestoenlosúltimos12meses"},
{"50": "50HassidodetenidoporlaPolicíaacusadodecometeralgúndelito"},
{"50A": "50ASucedióestoenlosúltimos12meses"},
{"51": "51AlgunodetusamigoshasidodetenidoalgunavezporlaPolicía"},
{"52": "52Enlosúltimos12meseshastomadoalgodeunatiendasinpagarporella"},
{"53": "53Enlosúltimos12meseshasparticipadoenalgunapeleaoriña"},
{"54": "54Enlosúltimos12meseshasllevadouncuchillopuñalomachete"},
{"54ACasa": "54ACasa"},
{"54AEscuela": "54AEscuela"},
{"54ABarrio": "54ABarrio"},
{"55": "55Enlosúltimos12meseshasllevadounarmadefuego"},
{"55ACasa": "55ACasa"},
{"55AEscuela": "55AEscuela"},
{"55ABarrio": "55ABarrio"},
{"56": "56Enlosúltimos12meseshasvistoaalguienqueestabasiendoapuñaladocortadoobaleado"},
{"56ACasa": "56ACasa"},
{"56AEscuela": "56AEscuela"},
{"56ABarrio": "56ABarrio"},
{"57": "57Enlosúltimos12mesesalguientehaamenazadoconuncuchilloounapistola"},
{"57ACasa": "57ACasa"},
{"57AEscuela": "57AEscuela"},
{"57ABarrio": "57ABarrio"},
{"58": "58Enlosúltimos12mesesalguientehacortadooapuñaladotangravementequetuvistequeiraunmédico"},
{"58ACasa": "58ACasa"},
{"58AEscuela": "58AEscuela"},
{"58ABarrio": "58ABarrio"},
{"59": "59Enlosúltimos12mesesalguientehadisparadoconunarmadefuego"},
{"59ACasa": "59ACasa"},
{"59AEscuela": "59AEscuela"},
{"59ABarrio": "59ABarrio"},
{"60": "60Enlosúltimos12meseshasamenazadoaalguienconcortarleapuñalarleodispararle"},
{"60ACasa": "60ACasa"},
{"60AEscuela": "60AEscuela"},
{"60ABarrio": "60ABarrio"},
{"61": "61Enlosúltimos12meseshasamenazadoaalguienconuncuchillooarma"},
{"61ACasa": "61ACasa"},
{"61AEscuela": "61AEscuela"},
{"61ABarrio": "61ABarrio"},
{"62": "62Enlosúltimos12meseshascortadooapuñaladoaalguien"},
{"62ACasa": "62ACasa"},
{"62AEscuela": "62AEscuela"},
{"62ABarrio": "62ABarrio"},
{"63": "63Enlosúltimos12meseslehasdisparadoaalguien"},
{"63ACasa": "63ACasa"},
{"63AEscuela": "63AEscuela"},
{"63ABarrio": "63ABarrio"},
{"64": "64Enlosúltimos12meseshastenidoalgúnamigoomiembrodetufamiliaquelehandisparadocortadooapuñalado"},
{"65": "65Hasdañadoodestruidoapropósitoartículosquenotepertenecen"},
{"66": "66Algunavezhassidoatacadoorobado"},
{"67": "67Algunavezhasatacadoorobadoaalguien"},
{"68": "68Algunavezhassidosecuestrado"},
{"69": "69Algunavezhassecuestradoaalguien"},
{"70": "70AlgunavezhasrobadoalgodeunatiendaoalgoquenotepertenecíaqueteníaunvalormenordeRD200"},
{"71": "71AlgunavezharobadoalgodeunatiendaoalgoquenotepertenecíaqueteníaunvalormayordeRD200incluyendocarros"},
{"72": "72Algunavezhasvendidooayudadoavenderdrogas"},
{"73": "73Hasestadoinvolucradoenunapandilla"},
{"73A": "73AActualmenteestásinvolucradoenunapandilla"},
{"74": "74Compartestiempooterelacionasconmiembrosdeunapandilla"},
{"74ACasa": "74ACasa"},
{"74AEscuela": "74AEscuela"},
{"74ABarrio": "74ABarrio"},
{"75": "75Enlosúltimos12meseshashabladoocompartidoconalguienborrachoodrogado"},
{"76": "76Algunavezhastomadounabebidaalcohólicaunacopavasoenteronosólounsorbo"},
{"76A": "76AEnlosúltimos12meseshasconsumidoalcohol"},
{"76B": "76BEnlosúltimos12meseshastomadocincovasoscopasomásdebebidasalcohólicasenelmismodía"},
{"77": "77Hasprobadoalgunavezcualquieradeestasdrogasmarihuanacocaínaheroínapastillascrackcementoocualquierotracosaparadrogarse"},
{"78": "78Hasusadoenalgunaocasiónunaagujaparainyectartedroga"},
{"79AMarihuana": "79AMarihuana"},
{"79BCrack": "79BCrack"},
{"79CCocaínaenpolvo": "79CCocaínaenpolvo"},
{"79DHeroína": "79DHeroína"},
{"79EMetanfetaminaocristal": "79EMetanfetaminaocristal"},
{"79FÉxtasisMDMA": "79FÉxtasisMDMA"},
{"79GInhalantescomopegamentocementopinturaspray": "79GInhalantescomopegamentocementopinturaspray"},
{"79HNoresponde": "79HNoresponde"},
{"79IOtrosespecifica": "79IOtrosespecifica"},
{"80AMarihuana": "80AMarihuana"},
{"80BCrack": "80BCrack"},
{"80CCocaínaenpolvo": "80CCocaínaenpolvo"},
{"80DHeroína": "80DHeroína"},
{"80EMetanfetaminaocristal": "80EMetanfetaminaocristal"},
{"80FÉxtasisMDMA": "80FÉxtasisMDMA"},
{"80GInhalantescomopegamentocementopinturaspray": "80GInhalantescomopegamentocementopinturaspray"},
{"80HNoresponde": "80HNoresponde"},
{"80IOtrosespecifica": "80IOtrosespecifica"},
{"81AMarihuana": "81AMarihuana"},
{"81BCrack": "81BCrack"},
{"81CCocaínaenpolvo": "81CCocaínaenpolvo"},
{"81DHeroína": "81DHeroína"},
{"81EMetanfetaminaocristal": "81EMetanfetaminaocristal"},
{"81FxtasisMDMA": "81FxtasisMDMA"},
{"81GInhalantescomopegamentocementopinturaspray": "81GInhalantescomopegamentocementopinturaspray"},
{"81HNoresponde": "81HNoresponde"},
{"81IOtrosespecifica": "81IOtrosespecifica"},
{"82": "82Algunavezhastenidorelacionessexuales"},
{"83": "83Quéedadteníaslaprimeravezquetuvisterelacionessexuales"},
{"84": "84Conquiéneshastenidorelacionessexuales"},
{"85": "85Concuántaspersonasdiferenteshastenidorelacionessexualesenlosúltimos12meses"},
{"86": "86Laúltimavezquetuvisterelacionessexualestuotucompañeroautilizóuncondón"},
{"87ANoutilicéningúnmétodoparaprevenirelembarazo": "87ANoutilicéningúnmétodoparaprevenirelembarazo"},
{"87BCondón": "87BCondón"},
{"87CCondónfemenino": "87CCondónfemenino"},
{"87DPíldoraanticonceptiva": "87DPíldoraanticonceptiva"},
{"87ERitmomantenerrelacionesendíasnofértilesocuandonohayovulación": "87ERitmomantenerrelacionesendíasnofértilesocuandonohayovulación"},
{"87FRetirodetenerlapenetraciónantesdeeyacular": "87FRetirodetenerlapenetraciónantesdeeyacular"},
{"87GMelamujereslactando": "87GMelamujereslactando"},
{"87HDIUcomoMirenaoParagard": "87HDIUcomoMirenaoParagard"},
{"87IInyeccióncomoDepoProveraunparcheOrthoEvraounanillocomoNuvaRing": "87IInyeccióncomoDepoProveraunparcheOrthoEvraounanillocomoNuvaRing"},
{"87JImplanteonorplantcomoImplanonoNexplanon": "87JImplanteonorplantcomoImplanonoNexplanon"},
{"87KEsterilizaciónfemenina": "87KEsterilizaciónfemenina"},
{"87LEsterilizaciónmasculina": "87LEsterilizaciónmasculina"},
{"87MNoséInseguro": "87MNoséInseguro"},
{"87NOtro": "87NOtro"},
{"88": "88Algunavezalguientehaobligadoatenerrelacionessexuales"},
{"89": "89Algunavezhastenidorelacionessexualespordinerobienescelularesviviendaetcoserviciosproteccióncomidaetc"},
{"89A": "89ASilarespuestaesafirmativaCuándofuelaúltimavez"},
{"90": "90Siquisierascompraruncondóncreesquepodríasencontrarlo"},
{"91": "91Siquisierastenersexocreesquepodriasconvenceratuparejadequeusecondónencasodequeélellaseniegueausarlo"},
{"92": "92Tesientescapazdetenerunaconversaciónabiertayhonestasobresexoconsuspadres"},
{"93": "93Algunavezhastenidounaconversaciónabiertayhonestasobresexocontuspadres"},
{"94": "94Algunavezalguientehaenseñadoohabladoacercadelasinfeccionesdetransmisiónsexual"},
{"94AOrientadoraoPsicólogoadelaescuela": "94AOrientadoraoPsicólogoadelaescuela"},
{"94APadreoMadre": "94APadreoMadre"},
{"94APromotoradeSalud": "94APromotoradeSalud"},
{"94AProfesoradelaescuela": "94AProfesoradelaescuela"},
{"94AInternet": "94AInternet"},
{"94AAmigos": "94AAmigos"},
{"94AOtroEspecifique": "94AOtroEspecifique"},
{"95": "95Algunavezlehanenseñadoacercadeprevencióndeembarazo"},
{"95AOrientadoraoPsicólogoadelaescuela": "95AOrientadoraoPsicólogoadelaescuela"},
{"95APadreoMadre": "95APadreoMadre"},
{"95APromotoradeSalud": "95APromotoradeSalud"},
{"95AProfesoradelaescuela": "95AProfesoradelaescuela"},
{"95AInternet": "95AInternet"},
{"95AAmigos": "95AAmigos"},
{"95AOtroEspecifique": "95AOtroEspecifique"},
{"96": "96AlgunavezlehanenseñadoacercalainfecciónporVIHSida"},
{"96AOrientadoraoPsicólogoadelaescuela": "96AOrientadoraoPsicólogoadelaescuela"},
{"96APadreoMadre": "96APadreoMadre"},
{"96APromotoradeSalud": "96APromotoradeSalud"},
{"96AProfesoradelaescuela": "96AProfesoradelaescuela"},
{"96AInternet": "96AInternet"},
{"96AAmigos": "96AAmigos"},
{"96AOtroEspecifique": "96AOtroEspecifique"}
  ];

    return surveyFields;
}