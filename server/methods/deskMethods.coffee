Meteor.methods
  saveDeskSnapshot: (projectId, title, description) ->
    console.log 'saveDeskSnapshot', projectId, title, description
    snapshotId = DeskSnapshots.insert
      projectId: projectId
      userId: @userId
      title: title
      description: description
      timestamp: new Date()
      widgets: DeskWidgets.find({projectId: projectId, userId: @userId}).map (w) ->
        delete w._id
        delete w.projectId
        delete w.userId
        return w

  loadDeskSnapshot: (snapshotId) ->
    snapshot = DeskSnapshots.findOne snapshotId

    DeskWidgets.remove
      projectId: snapshot.projectId
      userId: @userId

    _.each snapshot.widgets, (w) =>
      DeskWidgets.insert _.extend w,
        projectId: snapshot.projectId
        userId: @userId

  sendToExhibit: (projectId, manifestId, canvasImageId) ->
    # TODO: permissions check
    canvas = AvailableManifests.findOne(manifestId).manifestPayload.sequences[0].canvases[canvasImageId]
    imageId = canvas.images[0].resource.service['@id']

    now = new Date()

    folioItem = folioItems.findOne
      projectId: projectId
      imageURL: imageId

    newFolioId = folioItem?._id || folioItems.insert
      projectId: projectId
      addedBy: @userId
      lastUpdatedBy: @userId
      imageURL: imageId
      dateAdded: now
      lastUpdated: now
      published: false
      manifest: Meteor.absoluteUrl "folio/manifest.json"
      canvas: null
      annotations: null

    folioItems.update newFolioId,
      $set:
        lastUpdatedBy: @userId
        lastUpdated: now
        annotations: Annotations.find({
            projectId: projectId
            manifestId: manifestId
            canvasIndex: canvasImageId
          }, {fields: {type: 1, text: 1, x: 1, y: 1, w: 1, h: 1}}).fetch()
        canvas:
          "@id": Meteor.absoluteUrl "folio/canvas/#{newFolioId}"
          "@type": "sc:Canvas"
          label: canvas.label
          height: canvas.height || canvas.heigt
          width: canvas.width
          images: [
            "@id": Meteor.absoluteUrl "folio/image/#{newFolioId}"
            "@type": "oa:Annotation"
            motivation: "sc:painting"
            on: Meteor.absoluteUrl "folio/canvas/#{newFolioId}"
            resource:
              "@id": "#{imageId}/full/full/0/native.jpg"
              "@type": "dctypes:Image"
              format: "image/jpeg"
              height: canvas.images[0].resource.height
              width: canvas.images[0].resource.width
              service:
                "@id": imageId
                profile: "http://library.stanford.edu/iiif/image-api/1.1/conformance.html#level1"
          ]

    return newFolioId

