// Generated by CoffeeScript 1.6.3
(function(doc) {
  var val;
  val = "";
  val = '"Fecha":"' + doc.Fecha + '"';
  val += ',' + '"Nombre":"' + doc.Nombre + '"';
  val += ',' + '"Apellido":"' + doc.Apellido + '"';
  val += ',' + '"Apodo":"' + doc.Apodo + '"';
  val += ',' + '"Sexo":"' + doc.Sexo + '"';
  val += ',' + '"Día":"' + doc['Día'] + '"';
  val += ',' + '"Mes":"' + doc.Mes + '"';
  val += ',' + '"Año":"' + doc['Año'] + '"';
  val += ',' + '"Calleynumero":"' + doc.Calleynumero + '"';
  val += ',' + '"Provincia":"' + doc.Provincia + '"';
  val += ',' + '"Municipio":"' + doc.Municipio + '"';
  val += ',' + '"BarrioComunidad":"' + doc.BarrioComunidad + '"';
  if (doc.question === "Participant Registration-es" && doc.Completado === "true" && (doc.Estecolateralparticipante === void 0 || doc.Estecolateralparticipante !== "Sí")) {
    return emit(doc.uuid, "{" + val + "}");
  }
});

/*
//@ sourceMappingURL=map.map
*/
