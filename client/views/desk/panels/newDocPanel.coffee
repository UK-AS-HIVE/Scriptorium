Template.newDocPanel.events

  "click #saveAsDocument": ->
    Meteor.call "getNewEditorId", Meteor.userId(), Session.get('current_project'), $("#newDocName").val(), $("#newDocDesc").val()

Template.newDocPanel.events
  "click .js-close-panel": ->
    $('.desk-new-doc-panel').removeClass('is-open')
