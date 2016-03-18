Template.deskSnapshotPanel.events
  "click a.save-snapshot": ->
    Blaze.render Template.newSnapshotModal, $('body').get(0)
    $('#new-snapshot-modal').modal('show')

  "click .desk-snapshot-item": ->
    Meteor.call 'loadDeskSnapshot', @_id

Template.deskSnapshotPanel.helpers
  savedDesks: ->
    DeskSnapshots.find()

