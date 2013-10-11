# jquery helpers

( ($) -> 

  $.fn.getRandom = () -> 
    this[Math.floor(Math.random() * this.length)]

  $.fn.scrollTo = (speed = 500, callback) ->
    try
      $('html, body').animate {
        scrollTop: $(@).offset().top + 'px'
        }, speed, null, callback
    catch e
      console.log "error", e
      console.log "Scroll error with 'this'", @

    return @


  $.fn.safeVal = () ->
    if @is(":visible")
      return ( @val() || '' ).trim()
    else
      return null


)($)
