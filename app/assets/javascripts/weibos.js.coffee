hide_top_alert = ->
  $(".top-alert").slideToggle()
$(document).ready ->
   top_alert_time = setTimeout(hide_top_alert, 3000) 
