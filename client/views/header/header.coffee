Template.header.helpers
  availableProjects: ->
    projects = Projects.find({permissions: {$elemMatch: {user: Meteor.userId()}}})
    return projects

  isCurrentProject: (projectId) ->
    Session.get('current_project') == projectId

  hasCurrentProject: ->
    if Session.get('current_project') and Session.get('current_project') != "Free Space"
      return true
    else return false

Template.header.events
  "change #projectSelector": (e, tpl) ->
    Session.set "current_project", tpl.$(e.target).val()

  "click #saveAsProject": ->
    $('.desk-save-panel').toggleClass('is-open')

  "click .toggle-help-panel": ->
    $('.help-panel').toggleClass('is-open')
