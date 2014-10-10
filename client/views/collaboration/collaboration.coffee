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

  modalError: () ->
    Session.get('modal_error')
})

Collab = {
  addUser: (e, t) ->
    e.preventDefault()
    email = $(t.find('input[type=email]')).val()
    role = $(t.find('select')).val()
    Meteor.call('addUserToProject',
                Session.get('current_project'), email, role,
                (error, result) ->
                  if error
                    Session.set("modal_error", error.error)
                  else
                    Session.set("modal_error", null)
                    $('#userModal').modal('hide')
    )
}

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

    'click #userModal .closeMe': (e, t) ->
      Session.set('modal_error', null)
      $('#userModal input').val('')

    'submit #userModal form': (e,t) ->
      Collab.addUser(e,t)

    'click #userModal .addUser': (e, t) ->
      Collab.addUser(e,t)
})
