Template.desk.rendered = ->

  #SEO Page Title & Description
  document.title = "Scriptorium - Desk"

Template.desk.events
	"click #addManiButton": ->
		console.log($("#newManifestURL").val())
		Meteor.call("getManifest", $("#newManifestURL").val(), $("#newManifestLocation").val(), $("#newManifestTitle").val())