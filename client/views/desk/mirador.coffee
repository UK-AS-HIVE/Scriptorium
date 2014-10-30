Template.mirador.rendered = ->

  myObject = {"id": "viewer", "data": [{ "manifestUri": "http://loris.as.uky.edu/manifests/folio/manifest.json", "location": "HMML", "title": "Folio", "widgets": [{"type": "imageView", "openAt": "BL_add_ms_34294_vol_1-f014v", "width": 500}] }, { "manifestUri": "http://loris.as.uky.edu/manifests/Canones_Apostolorum.json", "location": "UK", "title": "Canones_Apostolorum", "widgets": [] }]}

  Meteor.setTimeout ( ->
		Mirador myObject
  ), 1000
