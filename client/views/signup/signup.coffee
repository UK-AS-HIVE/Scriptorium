Template.signUp.helpers
  error: -> Template.instance().error.get()
  success: -> Template.instance().success.get()
  accountApproval: -> Meteor.settings.public?.accountApproval

Template.signUp.events
  "submit form": (e, tpl) ->
    if !Meteor.settings.public?.accountApproval
      # No approval process, create the account and a project for it
      Accounts.createUser
        email: tpl.$('input[name=email]').val()
        password: tpl.$('input[name=password]').val()
        profile:
          firstName: tpl.$('input[name=firstName]').val()
          lastName: tpl.$('input[name=lastName]').val()
          institution: tpl.$('input[name=institution]').val()
          research: tpl.$('textarea[name=research]').val()
          newProjectRequest: tpl.$('textarea[name=newProjectRequest]').val()
          existingProjectRequest: tpl.$('input[name=existingProjectRequest]').val()
      , (err, res) ->
        if err
          tpl.error.set "Error creating user: #{err.message}"
        else
          newProjectId = Projects.insert
            projectName: Meteor.user().profile.lastName + ", " + Meteor.user().profile.firstName
            personal: Meteor.userId()
            permissions: [ { user: Meteor.userId(), level: "admin" } ]
            miradorData: []
          Session.set 'current_project', newProjectId
          Router.go('/welcome')

    else
      Meteor.call 'requestAccount',
        email: tpl.$('input[name=email]').val()
        firstName: tpl.$('input[name=firstName]').val()
        lastName: tpl.$('input[name=lastName]').val()
        institution: tpl.$('input[name=institution]').val()
        research: tpl.$('textarea[name=research]').val()
        newProjectRequest: tpl.$('textarea[name=newProjectRequest]').val()
        existingProjectRequest: tpl.$('input[name=existingProjectRequest]').val()
      , (err) ->
        if err
          tpl.error.set "Error creating user: #{err.message}"
        else
          tpl.success.set true

    e.preventDefault()

Template.signUp.onCreated ->
  @error = new ReactiveVar()
  @success = new ReactiveVar(false)
