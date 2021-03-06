Meteor.publishComposite 'project', (projectId) ->
  if Projects.findOne({_id: projectId, $or: [ { personal: @userId }, { 'permissions.user': @userId } ] })?
    {
    find: ->
      Projects.find { _id: projectId }
    children: [
      { find: -> Annotations.find { projectId: projectId } }
      { find: ->
          FileCabinet.find { project: projectId , editorLockedByUserId: { $in: [ @userId, null ] } }, { fields: { 'editorLockedByConnectionId': 1, content: 1 } }
        children: [
          {
            find: (fc) ->
              FileRegistry.find { _id: fc.fileRegistryId }
          }
        ]
      }
      {
        find: ->
          FileCabinet.find { project: projectId }, { fields: { 'editorLockedByConnectionId': 0 } }
        children: [
          {
            find: (fc) ->
              FileRegistry.find { _id: fc.fileRegistryId }
          }
        ]
      }
      { find: -> AvailableManifests.find { project: projectId } }
      { find: -> Messages.find { roomId: projectId } }
      { find: -> EventStream.find { projectId: projectId } }
      { find: -> DeskWidgets.find { userId: @userId, projectId: projectId } }
      { find: -> DeskSnapshots.find { projectId: projectId }, {fields: {widgets: 0}} }
      { find: -> folioItems.find { projectId: projectId } }
    ]
    }


Meteor.publish 'projects', ->
  if @userId
    Projects.find { $or: [
        { personal: @userId }
        { "permissions.user": @userId }
    ] }

Meteor.publish 'unsavedFile', (fileId) ->
  # For getting file information after upload, but before file is saved to FileCabinet.
  unless FileCabinet.findOne({ fileRegistryId: fileId })
    FileRegistry.find { _id: fileId }

Meteor.publish 'userData', ->
  Meteor.users.find { _id: @userId }

Meteor.publish 'allUserData', ->
  Meteor.users.find {}, { fields: { _id: 1, emails: 1, profile: 1 } }

Meteor.publish 'requestedAccounts', ->
  if Meteor.users.findOne { _id: @userId, 'emails.address': { $in: Meteor.settings.approval.approverEmails } }
    RequestedAccounts.find { }
  else return null

Meteor.publish 'requestedAccountForSignup', (id) ->
  RequestedAccounts.find { _id: id, approved: true, created: false }

Meteor.publish 'bookshelves', (projectId) ->
  # Called from client/views/bookshelf.coffee
  # Intentionally overlaps the 'project' subscription to compensate for a publishComposite bug
  if Projects.findOne({_id: projectId, $or: [ { personal: @userId }, { 'permissions.user': @userId } ] })?
    Bookshelves.find { project: projectId }

Meteor.publishComposite 'booksByBookshelfId', (bookshelfIds) ->
  bookshelfIds = _.filter bookshelfIds, (b) =>
    Projects.findOne({ _id: Bookshelves.findOne(b)?.project, $or: [ { personal: @userId }, { 'permissions.user': @userId } ] })?
  {
    find: ->
      Books.find { bookshelfId: { $in: bookshelfIds } }
    children: [
      { find: (book) -> FileRegistry.find { _id: book.fileRegistryId } }
    ]
  }

