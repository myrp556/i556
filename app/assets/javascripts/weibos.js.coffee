$(document).ready ->
  code = $("code").html()
  state = $("state").html()
  console.log "code: "+code
  console.log "state:"+state
  if (code && state)
    console.log 'post'
    $.post "https://api.weibo.com/oauth2/access_token", {clent_id: "2601417764", client_secret: "510fd9a175bc9f24d05514a6708c9517", grant_type: "authorization_code", code: "#{code}", redirect_uri: "http://i556.herokuapp.com/weibo"}, (data) ->
      console.log "data: "+data 
    
