Template.desk.rendered = ->

  #SEO Page Title & Description
  document.title = "Scriptorium - Desk"
  Meteor.call "getRootUrl", (err, data) ->
  	if err
  		console.log("error setting variable")
  	else
  		Session.set "rootURL", data



Template.desk.events
	"click #addManiButton": ->
		console.log($("#newManifestURL").val())
		Meteor.call("getManifest", $("#newManifestURL").val(), $("#newManifestLocation").val(), $("#newManifestTitle").val())