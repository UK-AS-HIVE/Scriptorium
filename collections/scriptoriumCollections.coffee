@AvailableManifests = new Meteor.Collection('availablemanifests')
@FileCabinet = new Meteor.Collection('filecabinet')
# class @folioItems extends Minimongoid
# 	 @_collection: new Meteor.Collection('folioitems')
@folioItems = new Meteor.Collection('folioitems')
@Projects = new Meteor.Collection('projects')

Meteor.publish('projects', () ->
  if @userId
    Projects.find({$or: [
        {personal: @userId},
        {"permissions.user": @userId}
    ]})
)

Meteor.publish('contributors', (projectId) ->
  project = Projects.findOne(projectId)
  if project
    Meteor.users.find({_id: {$in: _.map(project.permissions, (p) -> p.user)}})
)

Meteor.publish('findUser', (token) ->
  User.search(token)
)

@ProjectPermissions = new Meteor.Collection('projectpermissions')
