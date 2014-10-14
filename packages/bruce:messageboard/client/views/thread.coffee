Template.mbThread.helpers({
  breaklines: (text) ->
    if text
      t = text.trim()
      '<p>'+t.replace(/[\r\n]+/g,'</p><p>')+'</p>'
})

Template.mbThread.events({
  'click .reply button': (e, t) ->
    e.preventDefault()
    textarea = t.$('.reply textarea')
    message = textarea.val()
    Meteor.call('postToThread', @_id, message)
    textarea.val('')
})
