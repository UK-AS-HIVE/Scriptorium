Template.signUp.helpers
  error: -> Template.instance().error.get()
  success: -> Template.instance().success.get()

Template.signUp.events
  "submit form": (e, tpl) ->
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

        ###
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
        ###

    e.preventDefault()

Template.signUp.onCreated ->
  @error = new ReactiveVar()
  @success = new ReactiveVar(false)
