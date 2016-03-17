Template.deskSnapshotPanel.events
  "click .js-close-panel": ->
    $('.desk-snapshot-panel').removeClass('is-open')

  "click a.save-snapshot": ->
    Blaze.render Template.newSnapshotModal, $('body').get(0)
    $('#new-snapshot-modal').modal('show')

  "click .desk-snapshot-item": ->
    Meteor.call 'loadDeskSnapshot', @_id

Template.deskSnapshotPanel.helpers
  savedDesks: ->
    DeskSnapshots.find()

