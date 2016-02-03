@AvailableManifests = new Meteor.Collection('availablemanifests')
@Projects = new Meteor.Collection('projects')
@Annotations = new Meteor.Collection('annotations')
@Workspaces = new Meteor.Collection('workspaces')
@FileCabinet = new Meteor.Collection('filecabinet')
@OpenDocs = new Meteor.Collection('opendocs')
# class @folioItems extends Minimongoid
# 	 @_collection: new Meteor.Collection('folioitems')
@folioItems = new Meteor.Collection('folioitems')
@Bookshelves = new Meteor.Collection('bookshelves')
@Books = new Meteor.Collection('books')
@ProjectPermissions = new Meteor.Collection('projectpermissions')

if Meteor.isServer

  Meteor.publish 'fileregistry', ->
    FileRegistry.find()

  Meteor.publish 'availablemanifests', ->
    AvailableManifests.find()

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

  Meteor.publish 'opendocs', ->
    OpenDocs.find()

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
