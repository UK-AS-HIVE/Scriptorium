Template.header.helpers
  disconnected: ->
    Session.get('wasConnected') and !Meteor.status().connected

  availableProjects: ->
    Projects.find()

  isCurrentProject: (projectId) ->
    Session.get('current_project') is projectId

  isntPersonalProject: ->
    Projects.findOne(Session.get("current_project"))?.personal isnt Meteor.userId()

  exhibitManagerEnabled: ->
    Projects.findOne(Session.get("current_project"))?.projectName == "CC&C"

Template.header.events
  "change #projectSelector": (e, tpl) ->
    Session.set "current_project", tpl.$(e.target).val()

  "click a[data-action=createNewProject]": ->
    Blaze.render Template.createProjectModal, $('body').get(0)
    $('#createProjectModal').modal('show')

  "click a[data-action=toggleHelp]": ->
    $('.help-panel').toggleClass('is-open')

  'click button[data-action=reconnect]': ->
    Meteor.connection.reconnect()

Template.header.onRendered ->
  @autorun ->
    if Session.get('current_project')
      Meteor.users.update Meteor.userId(), { $set: { lastProjectId: Session.get('current_project') } }
    else
      Session.set 'current_project', Meteor.user()?.lastProjectId || Projects.findOne()?._id

Tracker.autorun ->
  if Meteor.status().connected then Session.set('wasConnected', true)
