Template._userManagement.helpers
  project: ->
    Projects.findOne Session.get("current_project")

  user: ->
    User.first @user

  isAdmin: ->
    projectId = Session.get("current_project")
    Projects.findOne({
      _id: projectId,
      permissions: { $elemMatch: { user: Meteor.userId(), level: 'admin' } }
    })

Template._userManagement.events
  'click [data-toggle=modal]': (e, tpl) ->
    modal = tpl.$(e.currentTarget).data('modal')
    Blaze.renderWithData Template[modal], @, $('body').get(0)
    $("##{modal}").modal('show')

Template.addUserModal.rendered = ->
  $('#userModal').on('shown.bs.modal', () ->
    $('#userModal input').first().focus()
  )

  Meteor.typeahead @.$('#addUserModal .typeahead')

Template.addUserModal.onCreated ->
  @error = new ReactiveVar

Template.addUserModal.helpers
  modalError: ->
    Template.instance().error.get()

  userSearch: ->
    users = User.find({}).fetch()
    names = []

    if users
      name = (u) -> "#{u.profile?.firstName} #{u.profile?.lastName}"
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

    names

Template.addUserModal.events
  'click button[data-action=addUser]': (e, tpl) ->
    email = tpl.$('input[name=addUserEmail]').val()
    role = tpl.$('select[name=role]').val()
    Meteor.call 'addUserToProject', Session.get('current_project'), email, role, (err, res) ->
      if err
        tpl.error.set err.error
      else
        tpl.$('#addUserModal').modal('hide')

  'hidden.bs.modal': (e, tpl) -> Blaze.remove tpl.view

Template.editUserModal.helpers
  editingUser: ->
    User.first @user

  isRole: (role) ->
    role is @level

Template.editUserModal.events
  'click button[data-action=save]': (e, tpl) ->
    role = tpl.$('select.role').val()
    Meteor.call 'editUserInProject', Session.get('current_project'), @user, role
    tpl.$('#editUserModal').modal('hide')

  'hidden.bs.modal': (e, tpl) -> Blaze.remove tpl.view

Template.removeUserModal.helpers
  editingUser: ->
    User.first @user

Template.removeUserModal.events
  'click button[data-action=remove]': (e, tpl) ->
    Meteor.call 'removeUserFromProject', Session.get('current_project'), @user
    tpl.$('#removeUserModal').modal('hide')

  'hidden.bs.modal': (e, tpl) -> Blaze.remove tpl.view
