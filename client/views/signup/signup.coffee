Template.signUp.helpers
  error: -> Template.instance().error.get()

Template.signUp.events
  "submit #signup-form": (e, tpl) ->
    fName = $("#signup-firstName").val()
    lName = $("#signup-lastName").val()
    email = $("#signup-email").val()
    pass = $("#signup-password").val()
    inst = $("#signup-instAffiliation").val()
    desc = $("#researchDesc").val()

    Accounts.createUser
      email: email
      password: pass
      profile:
        firstName: fName
        lastName: lName
        institution: inst
        research: desc
    , (err) ->

      if err
        tpl.error.set "Error creating user: #{err}"
      else
        # Create a new project as the new user's personal space
        newProjectId = Projects.insert {
          projectName: Meteor.user().profile.lastName + ", " + Meteor.user().profile.firstName
          personal: Meteor.userId()
          permissions: [ { user: Meteor.userId(), level: "admin" } ]
          miradorData: [
            { "manifestUri": "http://iiif.as.uky.edu/manifests/folio/folio.json", "location": "HMML", "title": "Folio", "widgets": [] },
            { "manifestUri": "http://loris.as.uky.edu/manifests/Canones_Apostolorum.json", "location": "UK", "title": "Canones_Apostolorum", "widgets": [] }
          ]
        }
        Session.set "current_project", newProjectId
        Router.go('/welcome')

    e.preventDefault()

Template.signUp.onCreated ->
  @error = new ReactiveVar()
