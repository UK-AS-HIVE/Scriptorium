Template.header.rendered = () ->
  Tracker.autorun(() ->
    projects = Projects.find({permissions: {$elemMatch: {user: Meteor.userId()}}}).fetch()

    #If there is no current_project selected grab the first one
    # and make it that one
    if !Session.get('current_project') && projects && projects.length > 0
      Session.set('current_project', projects[0]._id)
    #if there are absolutely no projects default to "Free Space"
    else if !Session.get('current_project') && projects && projects.length <= 0
      Session.set('current_project', 'Free Space')
  )

Template.header.helpers
  availableProjects: ->
    projects = Projects.find({permissions: {$elemMatch: {user: Meteor.userId()}}})
    return projects

  isCurrentProject: (projectId) ->
    Session.get('current_project') == projectId

  hasCurrentProject: ->
    if Session.get('current_project')
      return true
    else return false

Template.header.events({
  "change #projectSelector": (e) ->
    projId = $(e.target).val()
    Session.set("current_project", projId)
    if Router.current().route.name == "desk"
      Meteor.miradorFunctions.loadMirador()


  "click .js-toggle-desk-panel": ->
    $('.desk-document-panel').toggleClass('is-open')

  "click #saveAsProject": ->
    $('.desk-save-panel').toggleClass('is-open')
})
