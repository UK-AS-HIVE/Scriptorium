Meteor.startup ->

  #index file cabinet items for search
  FileCabinet._ensureIndex({
    "$**": "text"
  }, {
    "name": "File Cabinet Search"
  }, {
    "language": "none"
  })
  
  # Make sure any previously locked files are unlocked
  FileCabinet.update {}, { $set: { editorLockedByUserId: null, editorLockedByConnectionId: null } }, { multi: true }

  #fix db changes for Folio Items
  folioItems.update({"metadata.scriptLanguage": "Ge'ez"}, {$set: {"metadata.scriptLanguage": "Gǝʿǝz"}}, {multi: true})
  folioItems.update({"metadata.scriptAlphabet": "Ge'ez"}, {$set: {"metadata.scriptAlphabet": "Gǝʿǝz"}}, {multi: true})
  folioItems.update({"metadata.scriptTradition": "Ge'ez"}, {$set: {"metadata.scriptTradition": "Gǝʿǝz"}}, {multi: true})
  folioItems.update({"metadata.scriptLanguage": "Ukranian"}, {$set: {"metadata.scriptLanguage": "Ukrainian"}}, {multi: true})
  folioItems.update({"metadata.scriptAlphabet": "Hebrew (or Armanic)"}, {$set: {"metadata.scriptAlphabet": "Hebrew or Armanic"}}, {multi: true})

