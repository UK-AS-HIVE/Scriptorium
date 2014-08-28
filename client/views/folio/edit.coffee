Template.folioEdit.rendered = ->

  #DATE SLIDER
  $("#dateSlider").slider {
    tooltip: 'hide',
    min: -500,
    max: 2025,
    step: 25,
    value: [-500,2025]
  }

  $("#dateSlider").on "slide", (slideEvt) ->

    if slideEvt.value[0] < 0
      $("#firstDate").text Math.abs(slideEvt.value[0]) + " BC"
    else
      $("#firstDate").text slideEvt.value[0] + " AD"

    if slideEvt.value[1] < 0
      $("#lastDate").text Math.abs(slideEvt.value[1]) + " BC"
    else
      $("#lastDate").text slideEvt.value[1] + " AD"
    return

  #CK EDITOR
  CKEDITOR.replace('description')
  CKEDITOR.replace('features')
  CKEDITOR.replace('info')
  CKEDITOR.replace('transcription')

  #SELECT FIELDS
  $("#scriptName").select2 tags: []

  $("#scriptSelect").select2 {
    placeholder: "Select a Script Family"
    allowClear: true
  }

  $("#languageSelect").select2 {
    placeholder: "Select a Language"
    allowClear: true
  }

  $("#alphabetSelect").select2 {
    placeholder: "Select an Alphabet"
    allowClear: true
  }

Template.folioEdit.helpers
  editThumbnail: ->
    image = folioItems.findOne({_id: Session.get("editFolioItem")})
    console.log(image.imageURL + "/full/200,/0/native.jpg")
    image.imageURL + "/full/200,/0/native.jpg"
  folioTitle: ->
    image = folioItems.findOne({_id: Session.get("editFolioItem")})
    image.canvas.label

Template.folioEdit.languages = ->
  Manuscript.languages

Template.folioEdit.scripts = ->
  Manuscript.scripts

Template.folioEdit.alphabet = ->
  Manuscript.alphabet

Template.folioEdit.events 
  "click #submit": ->
    folioItem = {}
    folioItem.city = $("#city-field").val()
    folioItem.repository = $("#repository-field").val()
    folioItem.collection = $("#collection-field").val()
    folioItem.collectionNumber = $("#collectionNumber-field").val()
    folioItem.commonName = $("#commonName-field").val()
    folioItem.origin = $("#origin-field").val()
    folioItem.provenance = $("#provenance-field").val()
    folioItem.dateExpression = $("#dateExpression-field").val()
    folioItem.dateRange = $("#dateSlider").slider('getValue')
    folioItem.author = $("#author-field").val()
    folioItem.title = $("#title-field").val()
    folioItem.scriptName = $("#scriptName").val()
    folioItem.scrptFamily = $("#scriptSelect").select2('val')
    folioItem.scriptLanguage = $("#languageSelect").select2('val')
    folioItem.scriptAlphabet = $("#alphabetSelect").select2('val')
    folioItem.contributors = $("#contributor-field").val()
    folioItem.manuscriptLink = $("#link-field").val()
    folioItem.specificText = $("#folioText-field").val()
    folioItem.folioNumber = $("#folioNumber-field").val()
    folioItem.description = CKEDITOR.instances.description.getData()
    folioItem.features = CKEDITOR.instances.features.getData()
    folioItem.info = CKEDITOR.instances.info.getData()
    folioItem.transcription = CKEDITOR.instances.transcription.getData()

    folioItems.update({_id: Session.get("editFolioItem")}, {$set: {metadata: folioItem}})

  "click #publish": ->
    console.log("presses")
    folioItems.update({_id: Session.get("editFolioItem")}, {$set: {published: true}})