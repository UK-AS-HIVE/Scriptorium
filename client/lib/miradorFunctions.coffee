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

		