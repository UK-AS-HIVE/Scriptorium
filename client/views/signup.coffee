Template.signUp.events
	"submit #signup-form": (event) ->
		fName = $("#signup-firstName").val()
		lName = $("#signup-lastName").val()
		email = $("#signup-email").val()
		pass = $("#signup-password").val()
		inst = $("#signup-instAffiliation").val()
		desc = $("#researchDesc").val()

		Accounts.createUser {email: email, password: pass, profile: {firstName: fName, lastName: lName, institution: inst, research: desc}}, (err) ->
			if err
				console.log "error creating user" + err
			else
				# Create a new project as the new user's personal space
				console.log Meteor.userId()
				newProjectId = Projects.insert {
					projectName: Meteor.users.findOne({_id: Meteor.userId()}).profile.lastName + ", " + Meteor.users.findOne({_id: Meteor.userId()}).profile.firstName,
					personal: Meteor.userId(),
					miradorData: [{ "manifestUri": "http://iiif.as.uky.edu/manifests/folio/folio.json", "location": "HMML", "title": "Folio", "widgets": [] }, { "manifestUri": "http://loris.as.uky.edu/manifests/Canones_Apostolorum.json", "location": "UK", "title": "Canones_Apostolorum", "widgets": [] }],
					permissions: [{user: Meteor.userId(), level: "admin"}]
				}

				console.log "project: " + newProjectId

				Session.set "current_project", newProjectId
			return false


		event.preventDefault()