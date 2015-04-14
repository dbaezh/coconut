(function(document) {
  if (document.collection === "result" && document.question !="Attendance List" && (document.uuid === void 0 || document.uuid == null  || document.uuid =="" || document.uuid == undefined) ){
    if (document.Completado === "true") {
      return emit(document.question + ':true:' + document.lastModifiedAt, null);
    } else {
      return emit(document.question + ':false:' + document.lastModifiedAt, null);
    }
  }
});