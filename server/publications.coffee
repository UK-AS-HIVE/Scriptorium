Meteor.publishComposite 'project', (projectId) ->
  if Projects.findOne({_id: projectId, $or: [ { personal: @userId }, { 'permissions.user': @userId } ] })?
    {
    find: ->
      Projects.find { _id: projectId }
    children: [
      { find: -> Annotations.find { projectId: projectId } }
      { find: -> FileCabinet.find { project: projectId } }
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
      { find: -> DeskWidgets.find { projectId: projectId } }
      {
        find: -> Bookshelves.find { project: projectId }
        children: [
          {
            find: (bookshelf) -> Books.find { bookshelfId: bookshelf._id }
          }
        ]
      }
    ]
    }


Meteor.publish 'projects', ->
  if @userId
    Projects.find { $or: [
        { personal: @userId }
        { "permissions.user": @userId }
    ] }


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


Meteor.publish 'collaboration', (projectId) ->
  project = Projects.findOne(projectId)
  if project
    [
      Meteor.users.find()
      Messages.find {roomId: projectId}
    ]
