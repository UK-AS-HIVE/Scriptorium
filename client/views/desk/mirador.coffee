Template.mirador.rendered = ->

  myObject = {"id": "viewer", "data": [{ "manifestUri": "http://loris.as.uky.edu/manifests/folio/manifest.json", "location": "HMML", "title": "Folio", "widgets": [{"type": "imageView", "openAt": "BL_add_ms_34294_vol_1-f014v", "width": 500}] }, { "manifestUri": "http://loris.as.uky.edu/manifests/Canones_Apostolorum.json", "location": "UK", "title": "Canones_Apostolorum", "widgets": [] }]}

  thisObject = {"id": "viewer", "data": []}

  myMani = AvailableManifests.find().fetch()
  root = Session.get("rootURL")

  console.log root

  for item in myMani
    console.log "item: " + item
    thisObject["data"].push({"manifestUri": root + "manifest/" + item["_id"], "location": item["manifestLocation"], "title": item["manifestTitle"]})

  console.log thisObject

  Meteor.setTimeout ( ->
		Mirador thisObject
  ), 1000
