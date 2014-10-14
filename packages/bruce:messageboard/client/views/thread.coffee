Template.mbThread.helpers({
    breaklines: (text) ->
      if text
        t = text.trim()
        '<p>'+t.replace(/[\r\n]+/g,'</p><p>')+'</p>'
})
