Template.folioEdit.onRendered ->

  #get database record for this item to populate special fields
  item = folioItems.findOne({_id: Session.get("editFolioItem")}, {fields: {'metadata' : 1}})


  if item.metadata?.dateRange
    dateLow = item.metadata.dateRange[0]
    dateHigh = item.metadata.dateRange[1]
  else
    dateLow = -500
    dateHigh = 2025


  # set the label
  if dateLow < 0
    $("#firstDate").text Math.abs(dateLow) + " BC"
  else
    $("#firstDate").text Math.abs(dateLow) + " AD"

  if dateHigh < 0
    $("#lastDate").text Math.abs(dateHigh) + " BC"
  else
    $("#lastDate").text Math.abs(dateHigh) + " AD"


  #DATE SLIDER
  $("#dateSlider").slider {
    tooltip: 'hide',
    min: -500,
    max: 2025,
    step: 25,
    value: [dateLow, dateHigh]
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


  $("#deleteModal").on 'hidden.bs.modal', ->
    Router.go 'folio'

  #CK EDITOR
  CKEDITOR.replace('description')
  CKEDITOR.replace('features')
  CKEDITOR.replace('info')
  CKEDITOR.replace('transcription')

  #set ckeditor fields
  CKEDITOR.instances['description'].setData(item.metadata?.description)
  CKEDITOR.instances['features'].setData(item.metadata?.features)
  CKEDITOR.instances['info'].setData(item.metadata?.info)
  CKEDITOR.instances['transcription'].setData(item.metadata?.transcription)

  #SELECT FIELDS
  $("#scriptName").select2 tags: []
  $("#scriptName").select2("val", item.metadata?.scriptName)

  $("#scriptSelect").select2 {
    placeholder: "Select a Script Family"
    allowClear: true
  }
  $("#scriptSelect").select2("val", item.metadata?.scriptFamily)

  $("#languageSelect").select2 {
    placeholder: "Select a Language"
    allowClear: true
  }
  $("#languageSelect").select2("val", item.metadata?.scriptLanguage)

  $("#alphabetSelect").select2 {
    placeholder: "Select an Alphabet"
    allowClear: true
  }
  $("#alphabetSelect").select2("val", item.metadata?.scriptAlphabet)

  $("#traditionSelect").select2 {
    placeholder: "Select an Tradition"
    allowClear: true
  }
  $("#traditionSelect").select2("val", item.metadata?.scriptTradition)

  # FIX SIDEBAR ON SCROLL
  $('.sidebar-affix').affix
    offset:
      top: 240


Template.folioEdit.helpers
  editThumbnail: ->
    retrievalUrl = folioItems.findOne({_id: Session.get("editFolioItem")}).canvas.images[0].resource.service['@id'] + '/info.json'
    miradorFunctions.iiif_getUriWithHeight ImageMetadata.findOne({retrievalUrl: retrievalUrl}).payload, 200
  folioTitle: ->
    image = folioItems.findOne({_id: Session.get("editFolioItem")})
    image.canvas.label
  getFolioById: ->
    folioItems.findOne({_id: Session.get("editFolioItem")})
  isPublished: (published) ->
    item = folioItems.findOne({_id: Session.get("editFolioItem")}, {fields: {published: 1}})
    item.published == published
  languages: ->
    Manuscript.languages
  scripts: ->
    Manuscript.scripts
  alphabet: ->
    Manuscript.alphabet
  traditions: ->
    Manuscript.traditions


Template.folioEdit.events
  "click #submitFolioItem": ->
    folioItem = {}

    #required fields

    folioItem.city = $("#city-field").val()
    folioItem.repository = $("#repository-field").val()
    folioItem.collectionNumber = $("#collectionNumber-field").val()
    folioItem.dateRange = $("#dateSlider").slider('getValue')
    folioItem.scriptName = $("#scriptName").select2('val')
    folioItem.scriptFamily = $("#scriptSelect").select2('val')
    folioItem.scriptLanguage = $("#languageSelect").select2('val')
    folioItem.scriptAlphabet = $("#alphabetSelect").select2('val')
    folioItem.scriptTradition = $("#traditionSelect").select2('val')
    folioItem.specificText = $("#folioText-field").val()
    folioItem.folioNumber = $("#folioNumber-field").val()
    folioItem.description = CKEDITOR.instances.description.getData()
    folioItem.features = CKEDITOR.instances.features.getData()
    folioItem.transcription = CKEDITOR.instances.transcription.getData()

    # Non required fields
    folioItem.collection = $("#collection-field").val()
    folioItem.commonName = $("#commonName-field").val()
    folioItem.origin = $("#origin-field").val()
    folioItem.provenance = $("#provenance-field").val()
    folioItem.dateExpression = $("#dateExpression-field").val()
    folioItem.author = $("#author-field").val()
    folioItem.title = $("#title-field").val()
    folioItem.contributors = $("#contributor-field").val()
    folioItem.manuscriptLink = $("#link-field").val()
    folioItem.info = CKEDITOR.instances.info.getData()

    setter =
      lastUpdated: new Date()
      lastUpdatedBy: Meteor.userId()

    # Need to do this because Simple-Schema doesn't treat updating a subobject
    # the same as individual keys It converts empty-string subobjects to
    # $unset, rather than $set, so we need to specify them all explicitly
    for k,v of folioItem
      setter["metadata.#{k}"] = v

    folioItems.update({_id: Session.get("editFolioItem")}, {$set: setter})
    $("#folioSaveConfirm").modal('show')

  "click #folioSaveOkBtn": ->
    $("#folioSaveConfirm").modal('hide')

  "click #folioInvalidOkBtn": ->
    $("#folioInvalidField").modal('hide')

  "click #folioPublishOkBtn": ->
    $("#folioPublishConfirm").modal('hide')

  "hidden.bs.modal #folioPublishConfirm": (e) ->
    Router.go 'folio'

  "click #publish": ->
    #validate required fields
    emptyFields = []

    #required fields
    if $("#city-field").val() == ''
      emptyFields.push("City")

    if $("#repository-field").val() == ''
      emptyFields.push("Repository")

    if $("#collectionNumber-field").val() == ''
      emptyFields.push("Collection Number")

    if $("#scriptName").select2('val') == ''
      emptyFields.push("Script")

    if $("#scriptSelect").select2('val') == ''
      emptyFields.push("Script Family")

    if $("#languageSelect").select2('val') == ''
      emptyFields.push("Language")

    if $("#alphabetSelect").select2('val') == ''
      emptyFields.push("Alphabet")

    if $("#traditionSelect").select2('val') == ''
      emptyFields.push("Script Tradition")

    if $("#folioNumber-field").val() == ''
      emptyFields.push("Folio Number")

    if CKEDITOR.instances.description.getData() == ''
      emptyFields.push("Paleographic Description")

    if CKEDITOR.instances.features.getData() == ''
      emptyFields.push("Special Paleographic Features")

    if CKEDITOR.instances.transcription.getData() == ''
      emptyFields.push("Transcription")


    #save everything
    folioItem = {}

    #required fields
    folioItem.city = $("#city-field").val()
    folioItem.repository = $("#repository-field").val()
    folioItem.collectionNumber = $("#collectionNumber-field").val()
    folioItem.dateRange = $("#dateSlider").slider('getValue')
    folioItem.scriptName = $("#scriptName").select2('val')
    folioItem.scriptFamily = $("#scriptSelect").select2('val')
    folioItem.scriptLanguage = $("#languageSelect").select2('val')
    folioItem.scriptAlphabet = $("#alphabetSelect").select2('val')
    folioItem.scriptTradition = $("#traditionSelect").select2('val')
    folioItem.specificText = $("#folioText-field").val()
    folioItem.folioNumber = $("#folioNumber-field").val()
    folioItem.description = CKEDITOR.instances.description.getData()
    folioItem.features = CKEDITOR.instances.features.getData()
    folioItem.transcription = CKEDITOR.instances.transcription.getData()

    # Non required fields
    folioItem.collection = $("#collection-field").val()
    folioItem.commonName = $("#commonName-field").val()
    folioItem.origin = $("#origin-field").val()
    folioItem.provenance = $("#provenance-field").val()
    folioItem.dateExpression = $("#dateExpression-field").val()
    folioItem.author = $("#author-field").val()
    folioItem.title = $("#title-field").val()
    folioItem.contributors = $("#contributor-field").val()
    folioItem.manuscriptLink = $("#link-field").val()
    folioItem.info = CKEDITOR.instances.info.getData()

    theDate = new Date
    folioItems.update({_id: Session.get("editFolioItem")}, {$set: {metadata: folioItem, lastUpdated: theDate, lastUpdatedBy: Meteor.userId()}})


    item = folioItems.findOne({_id: Session.get("editFolioItem")}, {fields: {published: 1}})
    if item.published == true
      folioItems.update({_id: Session.get("editFolioItem")}, {$set: {published: false}})
      $("#folioPublishConfirm").modal("show")
    else
      if emptyFields.length < 1
        folioItems.update({_id: Session.get("editFolioItem")}, {$set: {published: true}})
        $("#folioPublishConfirm").modal("show")
      else
        $("#folioInvalidField").modal("show")

  "click #deleteFolioRecord": ->
    console.log "delete"
    folioItems.remove({_id: Session.get("editFolioItem")})
    $("#deleteModal").modal('hide')
    console.log "deleted"
