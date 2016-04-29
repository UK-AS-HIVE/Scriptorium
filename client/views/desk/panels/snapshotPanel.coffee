Template.snapshotPanel.events
  "click button.save-snapshot": ->
    Blaze.render Template.newSnapshotModal, $('body').get(0)
    $('#new-snapshot-modal').modal('show')

  "click .desk-snapshot-item": ->
    Meteor.call 'loadDeskSnapshot', @_id

Template.snapshotPanel.helpers
  savedDesks: ->
    DeskSnapshots.find {}, { sort: { timestamp: -1 } }
  formattedTimestamp: ->
    moment(@timestamp).format('lll')
  fullName: -> User.first(@userId)?.fullName()
