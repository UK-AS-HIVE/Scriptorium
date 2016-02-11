Meteor.methods
  addFolioItem: (imageID) ->
    now = new Date()

    newFolioID = folioItems.insert
      addedBy: @userId
      lastUpdatedBy: @userId
      canvas: null
      imageURL: imageID
      metadata: {}
      dateAdded: now
      lastUpdated: now
      published: false
      manifest: Meteor.absoluteUrl "folio/manifest.json"

    return newFolioID

  sendFolioPrep: (imageID, height, width, title) ->
    console.log(imageID + " " + height + " " + width + " " + title)
