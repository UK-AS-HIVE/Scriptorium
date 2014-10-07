Template.signUp.events
	"submit #signup-form": (event) ->
		fName = $("#signup-firstName").val()
		lName = $("#signup-lastName").val()
		email = $("#signup-email").val()
		pass = $("#signup-password").val()

		Accounts.createUser {email: email, password: pass, profile: {firstName: fName, lastName: lName}}, (err) ->
			if err
				console.log "error creating user" + err
			else
				alert "user created"
			return false


		event.preventDefault()