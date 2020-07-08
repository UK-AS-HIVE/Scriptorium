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
    canvases = manifest.manifestPayload.sequences[0].canvases
    total = canvases.length
    _.each canvases, Meteor.bindEnvironment (c, i) ->
      # retry up to 10 times with exponential backoff
      fetchWithRetries = ->
        try
          url = c.images[0].resource.service['@id'] + '/info.json'

          cached = ImageMetadata.findOne({manifestId: manifestId, retrievalUrl: url})
          twentyFourHours = 1000*60*60*24
          if cached?.retrievalTimestamp and (new Date().getTime() - cached.retrievalTimestamp < twentyFourHours) 
            console.log "Cache HIT  - #{url} (" + (i+1) + "/#{total}) (won't refetch)"
            return
          else
            console.log "Cache MISS - #{url} (" + (i+1) + "/#{total})"
          f = (attemptNo) ->
            Meteor.setTimeout ->
                console.log "Fetching #{url} (" + (i+1) + "/#{total} - attempt ##{attemptNo})"
                HTTP.get url, {npmRequestOptions: {rejectUnauthorized: false}}, (err, res) ->
                  if err
                    if attemptNo < 10
                      fetchWithRetries attemptNo+1
                    else
                      console.log err
                  else if res.statusCode is 200
                    ImageMetadata.upsert {manifestId: manifestId, retrievalUrl: url},
                      $set:
                        retrievalTimestamp: new Date()
                        payload: JSON.parse(res.content)
              ,
                100*Math.pow(2,attemptNo)
          f 1
        catch e
          throw new Meteor.Error e.message
      Meteor.setTimeout fetchWithRetries, i*100

  getMetadataPayloadFromUrl: (url) ->
    ImageMetadata.findOne({retrievalUrl: url}).payload
