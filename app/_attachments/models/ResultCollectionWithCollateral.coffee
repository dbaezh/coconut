class ResultCollectionWithCollateral extends Backbone.Collection
  model: Result
  url: '/result'
  db:
    view: "resultsByQuestionAndCompleteWithCollateral"

  fetch: (options = {}) ->

    unless options.include_docs?
      options.include_docs = true
    #TBD: For now hard-code to not modify all the links in prod but need to fix
    # I am using z to mark the end of the match
    #if options?.question
      options.descending = "true"
      if options.complete is `undefined` or options.complete is "true"
        options.startkey = options.question + ":" + "true" + ":z"
        options.endkey = options.question + ":" + "true"
      else
        options.startkey = options.question + ":" + "false" + ":z"
        options.endkey = options.question + ":" + "false"


# Note, this checks if isComplete is defined not if it is true
      #if options.isComplete?
      #  options.startkey = options.question + ":" + options.isComplete + ":z"
      #  options.endkey = options.question + ":" + options.isComplete
      #else
        #options.startkey = options.question + ":z"
        #options.endkey = options.question
    super(options)

  notSent: ->
    @.filter (result) ->
     not result.get("sentTo")?.length

  filteredByQuestionCategorizedByStatus: (questionType) ->
    returnObject = {}
    returnObject.complete = []
    returnObject.notCompete = []
    @each (result) ->
      return unless result.get("question") is questionType
      switch result.get("complete")
        when true
          returnObject.complete.push(result)
        else
          returnObject.notComplete.push(result)

    return returnObject

  filterByQuestionType: (questionType) ->
    @filter (result) ->
      return result.get("question") is questionType

  partialResults: (questionType) ->
    @filter (result) ->
      return result.get("question") is questionType and not result.complete()
