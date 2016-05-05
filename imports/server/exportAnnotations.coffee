exports.exportAnnotations = (projectId, manifestId, canvasIndex, res) ->
  # TODO: check user has access to project

  annotations = Annotations.find
    projectId: projectId
    manifestId: manifestId
    canvasIndex: canvasIndex

  res.writeHead 200,
    'Content-Type': 'application/zip'
    'Content-Disposition': "attachment; filename=\"annotations.zip\""

  JSZip = require 'jszip'
  zip = new JSZip()

  annotations.forEach (anno, i) ->
    zip.file "annotation-#{i}.json", JSON.stringify(anno)

    # TODO: write docx?

  # TODO: bagit

  zip
    .generateNodeStream {type:'nodebuffer',streamFiles:true}
    .pipe(res)
    .on 'end', ->
      console.log 'done writing zipfile to fs'

