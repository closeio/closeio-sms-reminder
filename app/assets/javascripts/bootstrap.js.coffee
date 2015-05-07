jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()
  $(".container").hide()
  $(".waiter").show()

ready = ->
  $(".container").show()
  $(".waiter").hide()
  ChangedMe()
$(document).ready(ready)
$(document).on('page:load', ready)

