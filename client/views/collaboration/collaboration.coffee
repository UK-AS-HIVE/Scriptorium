Template.collaboration.helpers({
  project: () ->
    projectId = Session.get("current_project")
    Projects.findOne(projectId)

  username: () ->
    user = Meteor.users.findOne(@user)
    "#{user.profile.firstName} #{user.profile.lastName}"
})
