Meteor.startup ->

  #index file cabinet items for search

  #fix db changes for Folio Items
  folioItems.update({"metadata.scriptLanguage": "Ge'ez"}, {$set: {"metadata.scriptLanguage": "Gǝʿǝz"}}, {multi: true})
  folioItems.update({"metadata.scriptAlphabet": "Ge'ez"}, {$set: {"metadata.scriptAlphabet": "Gǝʿǝz"}}, {multi: true})
  folioItems.update({"metadata.scriptTradition": "Ge'ez"}, {$set: {"metadata.scriptTradition": "Gǝʿǝz"}}, {multi: true})
  folioItems.update({"metadata.scriptLanguage": "Ukranian"}, {$set: {"metadata.scriptLanguage": "Ukrainian"}}, {multi: true})
  folioItems.update({"metadata.scriptAlphabet": "Hebrew (or Armanic)"}, {$set: {"metadata.scriptAlphabet": "Hebrew or Armanic"}}, {multi: true})


  if AvailableManifests.find().count() == 0
    Meteor.call("getManifest", "http://loris.as.uky.edu/manifests/folio/manifest.json", "HMML", "Folio", "Default", "Default")
    Meteor.call("getManifest", "http://loris.as.uky.edu/manifests/Canones_Apostolorum.json", "UK", "Canones_Apostolorum", "Default", "Default")