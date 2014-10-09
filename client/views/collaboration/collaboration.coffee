Template.collaboration.helpers({
  project: () ->
    projectId = Session.get("current_project")
    Projects.findOne(projectId)

  user: () ->
    User.first({_id: @user})

  editingUser: () ->
    User.first({_id: Session.get('editing_user')})

  isRole: (role) ->
    role == Session.get('editing_user_role')
})

Template.collaboration.events({
    'click .team .edit': (e) ->
      e.preventDefault()
      Session.set("editing_user", @user)
      Session.set("editing_user_role", @level)

    'click .team .delete': (e) ->
      e.preventDefault()
      Session.set("editing_user", @user)

    'click #deleteUserModal .btn-danger': (e) ->
      Meteor.call('removeUserFromProject', Session.get('current_project'), Session.get('editing_user'))
      $('#deleteUserModal').modal('hide')
})
