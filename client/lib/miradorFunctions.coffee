Meteor.miradorFunctions = 
	createFolioEntry:(imageID, height, width, title, userID) ->
		rootURL = Meteor.call("getRootUrl")
		Meteor.call "addFolioItem", imageID, userID, (err, data) ->
			if err
				console.log("error adding folio item")
			else
				newImage = {}
				newCanvas = {}
				newCanvas["@id"] = Session.get("rootURL") + "folio/canvas/" + data
				newCanvas["@type"] = "sc:Canvas"
				newCanvas["label"] = title
				newCanvas["height"] = height
				newCanvas["width"] = width

				newImage["@id"] = Session.get("rootURL") + "folio/image/" + data
				newImage["@type"] = "oa:Annotation"
				newImage["motivation"] = "sc:painting"
				newImage["on"] = Session.get("rootURL") + "folio/canvas/" + data
				newImage["resource"] = {"@id": imageID + "/full/full/0/native.jpg", "@type": "dctypes:Image", "format": "image/jpeg", "height": height, "width": width, "service": {"@id": imageID, "profile": "http://library.stanford.edu/iiif/image-api/1.1/conformance.html#level1"}}

				newCanvas["images"] = [newImage]

				folioItems.update({_id: data}, {$set: {canvas: newCanvas}})

				Session.set "editFolioItem", data

				Router.go('folioEdit')

	loadMirador:() ->
		#clear old mirador components
		# $(".mirador-viewer").remove()
		# $(".mirador-main-menu-bar").remove()
		# $(".mirador-status-bar").remove()
		$("[class^='mirador']").remove()	
		$("[class^='load-window']").off()	
		

		thisObject = {"id": "viewer", "data": []}
		currentProject = Session.get("current_project")
		if currentProject == "Free Space"
			myMani = AvailableManifests.find({$or: [{"project": "Default", "user": "Default"}, {"project": "Free Space", "user": Meteor.userId()}]}).fetch()
		else
			myMani = AvailableManifests.find({$or: [{"project": "Default", "user": "Default"}, {"project": currentProject}]}).fetch()
		root = Meteor.absoluteUrl()

		for item in myMani
			maniUri = root + "manifest/" + item["_id"] + "/" + Session.get("current_project")
			workspaces = Workspaces.find({"manifestUri": maniUri, "project": Session.get("current_project"), "user": Meteor.userId()}).fetch()
			if workspaces.length > 0
				widgets = workspaces[0].widgets
			else
				#this is a new login/project
				if Session.get("current_project") == "Free Space"
					widgets = []
				else
					#get current project info
					thisProject = Projects.find({"_id": Session.get("current_project")}).fetch()
					for data in thisProject[0].miradorData
						if data.manifestId == item["_id"]
							widgets = data.widgets


			thisObject["data"].push({"manifestUri": maniUri, "location": item["manifestLocation"], "title": item["manifestTitle"], "widgets": widgets})
		Mirador thisObject

	newDoc: (filename) ->
		$("#newDocName").val(filename)
		$('.desk-new-doc-panel').toggleClass('is-open')
