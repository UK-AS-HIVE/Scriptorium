Template.mirador.rendered = ->

  myObject = {"id": "viewer", "data": [{ "manifestUri": "http://localhost:3000/folio/manifest.json", "location": "local", "title": "folio", "widgets": [] }, { "manifestUri": "http://iiif.as.uky.edu/manifests/folio/folio.json", "location": "HMML", "title": "Folio", "widgets": [] }]}

  Meteor.setTimeout ( ->
		Mirador(myObject) )
  , 1000
