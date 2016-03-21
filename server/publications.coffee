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
      {
        find: -> AvailableManifests.find { project: projectId }
        children: [
          {
            find: (manifest) -> ImageMetadata.find { manifestId: manifest._id }
          }
        ]
      }
      { find: -> Messages.find { roomId: projectId } }
      { find: -> EventStream.find { projectId: projectId } }
      { find: -> DeskWidgets.find { userId: @userId, projectId: projectId } }
      { find: -> DeskSnapshots.find { projectId: projectId }, {fields: {widgets: 0}} }
      {
        find: -> Bookshelves.find { project: projectId }
        children: [
          {
            find: (bookshelf) -> Books.find { bookshelfId: bookshelf._id }
            children: [
              {
                find: (book) ->
                  FileRegistry.find { _id: book.fileRegistryId }
              }
            ]
          }
        ]
      }
      {
        find: -> folioItems.find { projectId: projectId }
      }
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

Meteor.publish 'filecabinetsearch', (searchVal) ->
  console.log searchVal
  if searchVal == ""
    FileCabinet.find()
  else
    FileCabinet.find { $text: { $search: searchVal } }

