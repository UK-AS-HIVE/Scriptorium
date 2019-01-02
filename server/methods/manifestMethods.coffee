Meteor.methods
  getManifest: (url, location, title, project) ->
    try
      res = HTTP.get url
      if res.statusCode is 200
        Meteor.call 'retrieveImageInfo', AvailableManifests.insert
          user: @userId
          project: project
          manifestPayload: JSON.parse(res.content)
          manifestLocation: location
          manifestTitle: title
    catch e
      throw new Meteor.Error(e.message)

  retrieveImageInfo: (manifestId) ->
    manifest = AvailableManifests.findOne manifestId
    console.log "Retrieving image metadata for manifest #{manifest.manifestTitle}"
    _.each manifest.manifestPayload.sequences[0].canvases, (c) ->
      try
        url = c.images[0].resource.service['@id'] + '/info.json'
        console.log "Caching #{url}"
        HTTP.get url, {npmRequestOptions: {rejectUnauthorized: false}}, (err, res) ->
          if err
            console.log err
          if res.statusCode is 200
            ImageMetadata.upsert {manifestId: manifestId, retrievalUrl: url},
              $set:
                retrievalTimestamp: new Date()
                payload: JSON.parse(res.content)
      catch e
        throw new Meteor.Error e.message

  getMetadataPayloadFromUrl: (url) ->
    ImageMetadata.findOne({retrievalUrl: url}).payload
