@AvailableManifests = new Meteor.Collection('availablemanifests')
@FileCabinet = new Meteor.Collection('filecabinet')
@OpenDocs = new Meteor.Collection('opendocs')
# class @folioItems extends Minimongoid
# 	 @_collection: new Meteor.Collection('folioitems')
@folioItems = new Meteor.Collection('folioitems')
@Projects = new Meteor.Collection('projects')
@Annotations = new Meteor.Collection('annotations')
@Workspaces = new Meteor.Collection('workspaces')

@ProjectPermissions = new Meteor.Collection('projectpermissions')

if Meteor.isServer

  Meteor.publish('projects', () ->
    if @userId
      Projects.find({$or: [
          {personal: @userId},
          {"permissions.user": @userId}
      ]})
  )

  Meteor.publish('collaboration', (projectId) ->
    project = Projects.findOne(projectId)
    if project
      [
        Meteor.users.find({}),
        Messages.find({roomId: projectId})
      ]
  )
