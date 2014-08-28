Template.mirador.rendered = ->

  myObject = {"id": "viewer", "data": [{ "manifestUri": "http://dms-data.stanford.edu/data/manifests/Walters/qm670kv1873/manifest.json", "location": "Stanford University", "title": "W.168", "widgets": [] }, { "manifestUri": "http://iiif.as.uky.edu/manifests/folio/folio.json", "location": "HMML", "title": "Folio", "widgets": [] }]}

  Meteor.setTimeout ( ->
		Mirador(myObject) )
  , 1000
