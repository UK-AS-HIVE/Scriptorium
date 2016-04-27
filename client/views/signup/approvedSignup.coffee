Template.approvedSignup.events
  'submit form': (e, tpl) ->
    e.preventDefault()
    Accounts.createUser
      email: tpl.data.email
      password: tpl.$('input[name=password]').val()
      profile:
        firstName: tpl.data.firstName
        lastName: tpl.data.lastName
        institution: tpl.data.institution
        research: tpl.data.research
    , (err) ->
      if err
        tpl.error.set "Error creating user: #{err}"
      else

        # Create a new project as the new user's personal space
        newProjectId = Projects.insert
          projectName: Meteor.user().profile.lastName + ", " + Meteor.user().profile.firstName
          personal: Meteor.userId()
          permissions: [ { user: Meteor.userId(), level: "admin" } ]
          miradorData: []

        Session.set "current_project", newProjectId
        Router.go('/welcome')

Template.approvedSignup.onCreated ->
  @error = new ReactiveVar()

Template.approvedSignup.helpers
  error: -> Template.instance().error.get()
