@miradorFunctions = @miradorFunctions || {}
@miradorFunctions = _.extend @miradorFunctions,
  iiif_getUriWithHeight: (imageInfo, height) ->
    check imageInfo, Object
    check imageInfo['@context'], String
    check height, Number

    quality = if /2/.test(imageInfo['@context']) then 'default' else 'native'
    imageInfo['@id'] + "/full/,#{height}/0/#{quality}.jpg"

