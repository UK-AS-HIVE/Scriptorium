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

Template.addUserModal.onCreated ->
  @error = new ReactiveVar

Template.addUserModal.helpers
  error: ->
    Template.instance().error.get()
  searchSettings: ->
    {
      position: 'bottom'
      limit: 5
      rules: [
        {
          collection: Meteor.users
          field: 'emails.address'
          template: Template.userAutocomplete
          selector: (match) ->
            r = new RegExp match, 'i'
            return { $or: [ { username: r }, { 'profile.firstName': r }, { 'profile.lastName': r }, { 'emails.address': r } ] }
        }
      ]
    }

Template.userAutocomplete.helpers
  name: -> User.first(@_id).fullName()
  email: -> @emails[0].address

Template.addUserModal.events
  'autocompleteselect': (e, tpl, doc) ->
    # Have to set the autocomplete manually since our field is an array.
    tpl.$('input[name=addUserEmail]').val(doc?.emails[0]?.address)

  'click button[data-action=addUser]': (e, tpl) ->
    email = tpl.$('input[name=addUserEmail]').val()
    role = tpl.$('select[name=role]').val()
    Meteor.call 'addUserToProject', Session.get('current_project'), email, role, (err, res) ->
      if err
        tpl.error.set err.error
      else
        tpl.$('#addUserModal').modal('hide')

  'hidden.bs.modal': (e, tpl) -> Blaze.remove tpl.view

Template.editUserModal.onCreated ->
  @error = new ReactiveVar
Template.editUserModal.helpers
  error: ->
    Template.instance().error.get()
  editingUser: ->
    User.first @user

  isRole: (role) ->
    role is @level

Template.editUserModal.events
  'click button[data-action=save]': (e, tpl) ->
    role = tpl.$('select[name=role]').val()
    Meteor.call 'editUserInProject', Session.get('current_project'), @user, role, (err, res) ->
      if err
        tpl.error.set err.error
      else
        tpl.$('#editUserModal').modal('hide')

  'hidden.bs.modal': (e, tpl) -> Blaze.remove tpl.view

Template.removeUserModal.onCreated ->
  @error = new ReactiveVar
Template.removeUserModal.helpers
  error: ->
    Template.instance().error.get()
  editingUser: ->
    User.first @user

Template.removeUserModal.events
  'click button[data-action=remove]': (e, tpl) ->
    Meteor.call 'removeUserFromProject', Session.get('current_project'), @user, (err, res) ->
      if err
        tpl.error.set err.error
      else
        tpl.$('#removeUserModal').modal('hide')

  'hidden.bs.modal': (e, tpl) -> Blaze.remove tpl.view
