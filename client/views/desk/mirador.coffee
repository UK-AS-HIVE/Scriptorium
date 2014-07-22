Template.mirador.rendered = ->

  myObject = {"id": "viewer", "data": [{ "manifestUri": "http://manifests.ydc2.yale.edu/manifest/Osbornfa1.json", "location": "Yale University", "title": "Osborn fa1", "widgets": [] }]}

  Meteor.setTimeout ( ->
		Mirador(myObject) )
  , 1000
