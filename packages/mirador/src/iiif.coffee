@miradorFunctions = @miradorFunctions || {}
@miradorFunctions = _.extend @miradorFunctions,
  iiif_getUri: (uri) ->
    iiifUri = uri
    match = /http?:\/\/stacks.stanford.edu\/image\/(\w+\/\S+)/i.exec(uri)
    if match and match.length is 2
      iiifUri = 'https://stacks.stanford.edu/image/iiif/' + encodeURIComponent(match[1])
    return iiifUri

  iiif_prepJsonForOsd: (json) ->
    json.image_host    = miradorFunctions.iiif_getImageHostUrl json
    json.scale_factors = miradorFunctions.iiif_packageScaleFactors json
    json.profile       = json.profile.replace(/image-api\/1.\d/, 'image-api')

    if !json.tile_width
      json.tile_width = 256
      json.tile_height = 256

    return json


  iiif_getImageHostUrl: (json) ->
    matches = []

    if !json.hasOwnProperty('image_host')
      json.image_host = json.tilesUrl || json['@id'] || ''

    if json.hasOwnProperty('identifier')
      regex = new RegExp('/?' + json.identifier + '/?$', 'i')
      json.image_host = json.image_host.replace(regex, '')

    else
      regex = new RegExp('(.*)\/(.*)$')
      matches = regex.exec(json.image_host)
      if matches.length > 1
        json.image_host = matches[1]
        json.identifier = matches[2]

    return json.image_host


  iiif_packageScaleFactors: (json) ->
    newScaleFactors = []

    if json.hasOwnProperty('scale_factors') and _.isArray(json.scale_factors)
      i = 0
      while i < json.scale_factors.length
        newScaleFactors.push(i)
        i++

    return newScaleFactors

  iiif_getUriWithHeight: (uri, height) ->
    uri = uri.replace /\/$/, ''
    miradorFunctions.getUri(uri) + '/full/,' + height + '/0/native.jpg'

