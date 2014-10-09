Template.collaboration.helpers({
  project: () ->
    projectId = Session.get("current_project")
    Projects.findOne(projectId)

  user: () ->
    User.first({_id: @user})
})

Template.collaboration.events({
    'click .team .edit': (e) ->
      e.preventDefault()
      Session.set("editing_user", @user)
})
