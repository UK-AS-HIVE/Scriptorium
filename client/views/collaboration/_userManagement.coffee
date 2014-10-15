Template._userManagement.helpers({
  project: () ->
    projectId = Session.get("current_project")
    Projects.findOne(projectId)

  user: () ->
    User.first({_id: @user})

  isAdmin: () ->
    projectId = Session.get("current_project")
    Projects.findOne({
      _id: projectId,
      permissions: {$elemMatch: {user: Meteor.userId(), level: 'admin'}}
    })

})

Template._userManagement.events({
  'click .team .edit': (e) ->
    e.preventDefault()
    Session.set("editing_user", @user)
    Session.set("editing_user_role", @level)

  'click .team .delete': (e) ->
    e.preventDefault()
    Session.set("editing_user", @user)
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

Template.addUserToProject.rendered = () ->
  $('#userModal').on('shown.bs.modal', () ->
    $('#userModal input').first().focus();
  )

  Meteor.typeahead($('#userModal .typeahead'));

Template.addUserToProject.helpers({
  modalError: () ->
    Session.get('modal_error')

  userSearch: () ->
    users = User.find({}).fetch()
    names = []

    if users
      name = (u) -> "#{u.profile.firstName} #{u.profile.lastName}"
      email = (u) -> u.emails[0].address

      names = _.map(users, (u) ->
        {
          name: name(u),
          value: email(u),
          email: email(u),
          tokens: [
            email(u),
            u.profile.firstName,
            u.profile.lastName
          ]
        }
      )

    #console.log('search', names, users)

    #Session.get('typeahead_users') || []
    names
})

Template.addUserToProject.events({
  'click #userModal .closeMe': (e, t) ->
    Session.set('modal_error', null)
    $('#userModal input').val('')

  'submit #userModal form': (e,t) ->
    Collab.addUser(e,t)

  'click #userModal .addUser': (e, t) ->
    Collab.addUser(e,t)
})

Template.editUserInProject.helpers({
  editingUser: () ->
    User.first({_id: Session.get('editing_user')})

  isRole: (role) ->
    role == Session.get('editing_user_role')
})

Template.editUserInProject.events({
  'click #editUserModal .save': (e,t) ->
    e.preventDefault()
    userId = Session.get('editing_user')
    role = $(t.find('select.role')).val()
    Meteor.call('editUserInProject', Session.get('current_project'), userId, role)
    $('#editUserModal').modal('hide')
})

Template.removeUserFromProject.helpers({
  editingUser: () ->
    User.first({_id: Session.get('editing_user')})
})

Template.removeUserFromProject.events({
  'click #deleteUserModal .btn-danger': (e) ->
    Meteor.call('removeUserFromProject', Session.get('current_project'), Session.get('editing_user'))
    $('#deleteUserModal').modal('hide')
})
