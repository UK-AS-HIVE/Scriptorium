Template.newDocPanel.events

  "click #saveAsDocument": ->
    Meteor.call("getNewEditorId", Meteor.userId(), Session.get('current_project'), $("#newDocName").val(), $("#newDocDesc").val(), (err, res) ->
      console.log "clicked save"
      Meteor.call("openDoc", Meteor.userId(), Session.get('current_project'), res)
    )

Template.newDocPanel.events
  "click .js-close-panel": ->
    $('.desk-new-doc-panel').removeClass('is-open')
