Meteor.publish 'userData', ->
  Meteor.users.find { _id: @userId }

Meteor.publish 'allUserData', ->
  Meteor.users.find {}, { fields: { _id: 1, emails: 1, profile: 1 } }

Meteor.publish "getFolioRecords", ->
  folioItems.find { published: true }, { fields: { canvas: 0 } }

Meteor.publish 'fileregistry', ->
  FileRegistry.find()

Meteor.publish 'availablemanifests', ->
  [AvailableManifests.find(), ImageMetadata.find()]

Meteor.publish 'workspaces', ->
  Workspaces.find()

Meteor.publish 'annotations', ->
  Annotations.find()

Meteor.publish 'filecabinet', ->
  FileCabinet.find()

Meteor.publish 'filecabinetsearch', (searchVal) ->
  console.log searchVal
  if searchVal == ""
    FileCabinet.find()
  else
    FileCabinet.find { $text: { $search: searchVal } }

Meteor.publish 'folioitems', ->
  folioItems.find()

Meteor.publish 'bookshelves', ->
  Bookshelves.find()

Meteor.publish 'books', ->
  Books.find()

Meteor.publish 'projects', ->
  if @userId
    Projects.find { $or: [
        { personal: @userId }
        { "permissions.user": @userId }
    ] }

Meteor.publish 'collaboration', (projectId) ->
  project = Projects.findOne(projectId)
  if project
    [
      Meteor.users.find()
      Messages.find {roomId: projectId}
    ]
