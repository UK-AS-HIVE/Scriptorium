Template.mirador.rendered = ->

  myObject = {"id": "viewer", "data": [{ "manifestUri": "http://manifests.ydc2.yale.edu/manifest/BeineckeMS10.json", "location": "Yale University", "title": "Beinecke MS 10", "widgets": [] }, { "manifestUri": "http://iiif.as.uky.edu/manifests/folio/folio.json", "location": "HMML", "title": "Folio", "widgets": [] }]}

  Meteor.setTimeout ( ->
		Mirador(myObject) )
  , 1000
