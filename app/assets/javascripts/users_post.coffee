$(document).ready ->
  $(".table-tr").each ->
    user_id=$(this).attr('user_id')
    $(this).click ->
      window.location.href = "/post/#{user_id}" 
