function(doc) {
  if (doc._id === "Participant Survey-es") {
    return emit(doc._id, null);
  }
}