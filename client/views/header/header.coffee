Template.header.helpers
  availableProjects: ->
    Projects.find()

  isCurrentProject: (projectId) ->
    Session.get('current_project') is projectId

  isntPersonalProject: ->
    Projects.findOne(Session.get("current_project"))?.personal isnt Meteor.userId()

Template.header.events
  "change #projectSelector": (e, tpl) ->
    Session.set "current_project", tpl.$(e.target).val()

  "click a[data-action=createNewProject]": ->
    Blaze.render Template.createProjectModal, $('body').get(0)
    $('#createProjectModal').modal('show')

  "click a[data-action=toggleHelp]": ->
    $('.help-panel').toggleClass('is-open')

Template.header.onRendered ->
  @autorun ->
    if Session.get('current_project')
      Meteor.users.update Meteor.userId(), { $set: { lastProjectId: Session.get('current_project') } }
    else
      Session.set 'current_project', Meteor.user()?.lastProjectId || Projects.findOne()?._id





