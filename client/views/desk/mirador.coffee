Template.mirador.rendered = ->

  myObject = {"id": "viewer", "data": [{ "manifestUri": "http://www.shared-canvas.org/impl/demo1d/res/manifest.json", "location": "Shared Canvas", "title": "Pierpont Morgan MS.804", "widgets": [] }, { "manifestUri": "http://iiif.as.uky.edu/manifests/folio/folio.json", "location": "HMML", "title": "Folio", "widgets": [] }]}

  Meteor.setTimeout ( ->
		Mirador(myObject) )
  , 1000
