Meteor.subscribe('stuff')

Template.folioEdit.rendered = ->

  #get database record for this item to populate special fields
  item = folioItems.findOne({_id: Session.get("editFolioItem")}, {fields: {'metadata' : 1}})


  if item.metadata.dateRange
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
  CKEDITOR.instances['description'].setData(item.metadata.description)
  CKEDITOR.instances['features'].setData(item.metadata.features)
  CKEDITOR.instances['info'].setData(item.metadata.info)
  CKEDITOR.instances['transcription'].setData(item.metadata.transcription)

  #SELECT FIELDS
  $("#scriptName").select2 tags: []
  $("#scriptName").select2("val", item.metadata.scriptName)

  $("#scriptSelect").select2 {
    placeholder: "Select a Script Family"
    allowClear: true
  }
  $("#scriptSelect").select2("val", item.metadata.scriptFamily)

  $("#languageSelect").select2 {
    placeholder: "Select a Language"
    allowClear: true
  }
  $("#languageSelect").select2("val", item.metadata.scriptLanguage)

  $("#alphabetSelect").select2 {
    placeholder: "Select an Alphabet"
    allowClear: true
  }
  $("#alphabetSelect").select2("val", item.metadata.scriptAlphabet)

  $("#traditionSelect").select2 {
    placeholder: "Select an Tradition"
    allowClear: true
  }
  $("#traditionSelect").select2("val", item.metadata.scriptTradition)


Template.folioEdit.helpers
  editThumbnail: ->
    image = folioItems.findOne({_id: Session.get("editFolioItem")})
    image.imageURL + "/full/200,/0/native.jpg"
  folioTitle: ->
    image = folioItems.findOne({_id: Session.get("editFolioItem")})
    image.canvas.label
  getFolioById: ->
    folioItems.findOne({_id: Session.get("editFolioItem")})
  isPublished: (published) ->
    item = folioItems.findOne({_id: Session.get("editFolioItem")}, {fields: {published: 1}})
    item.published == published

Template.folioEdit.languages = ->
  Manuscript.languages

Template.folioEdit.scripts = ->
  Manuscript.scripts

Template.folioEdit.alphabet = ->
  Manuscript.alphabet

Template.folioEdit.traditions = ->
  Manuscript.traditions

Template.folioEdit.events 
  "click #submitFolioItem": ->
    folioItem = {}
    emptyFields = []

    #required fields
    # if $("#city-field").val() != ''
    #   folioItem.city = $("#city-field").val()
    # else
    #   emptyFields.push("City")

    # if $("#repository-field").val() != '' 
    #   folioItem.repository = $("#repository-field").val()
    # else
    #   emptyFields.push("Repository")

    # if $("#collectionNumber-field").val() != ''  
    #   folioItem.collectionNumber = $("#collectionNumber-field").val()
    # else
    #   emptyFields.push("Collection Number")

    # #dunno how to really validate this one  
    # folioItem.dateRange = $("#dateSlider").slider('getValue')

    # if $("#scriptName").select2('val') != ''
    #   folioItem.scriptName = $("#scriptName").select2('val')
    # else
    #   emptyFields.push("Script")

    # if $("#scriptSelect").select2('val') != ''
    #   folioItem.scriptFamily = $("#scriptSelect").select2('val')
    # else
    #   emptyFields.push("Script Family")

    # if $("#languageSelect").select2('val') != ''  
    #   folioItem.scriptLanguage = $("#languageSelect").select2('val')
    # else
    #   emptyFields.push("Language")

    # if $("#alphabetSelect").select2('val') != ''  
    #   folioItem.scriptAlphabet = $("#alphabetSelect").select2('val')
    # else
    #   emptyFields.push("Alphabet")

    # if $("#traditionSelect").select2('val') != ''
    #   folioItem.scriptTradition = $("#traditionSelect").select2('val')
    # else
    #   emptyFields.push("Script Tradition")

    # if $("#folioNumber-field").val() != ''  
    #   folioItem.folioNumber = $("#folioNumber-field").val()
    # else
    #   emptyFields.push("Folio Number")
    
    # if CKEDITOR.instances.description.getData() != ''
    #   folioItem.description = CKEDITOR.instances.description.getData()
    # else
    #   emptyFields.push("Paleographic Description")

    # if CKEDITOR.instances.features.getData() != ''
    #   folioItem.features = CKEDITOR.instances.features.getData()
    # else
    #   emptyFields.push("Special Paleographic Features")

    # if CKEDITOR.instances.info.getData() != ''
    #   folioItem.info = CKEDITOR.instances.info.getData()
    # else
    #   emptyFields.push("Further Information / Bibliography")

    # if CKEDITOR.instances.transcription.getData() != ''
    #   folioItem.transcription = CKEDITOR.instances.transcription.getData()
    # else
    #   emptyFields.push("Transcription")

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

    folioItem.folioNumber = $("#folioNumber-field").val()

    folioItem.description = CKEDITOR.instances.description.getData()

    folioItem.features = CKEDITOR.instances.features.getData()

    folioItem.info = CKEDITOR.instances.info.getData()

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
    folioItem.specificText = $("#folioText-field").val()

    theDate = new Date

    if emptyFields.length < 1
      $("#folioSaveConfirm").modal('show')
      folioItems.update({_id: Session.get("editFolioItem")}, {$set: {metadata: folioItem, lastUpdated: theDate, lastUpdatedBy: Meteor.userId()}})
    else
      $("#folioInvalidField").modal('show')
    


  "click #folioSaveOkBtn": ->
    $("#folioSaveConfirm").modal('hide')

  "click #folioInvalidOkBtn": ->
    $("#folioInvalidField").modal('hide')

  "click #folioPublishOkBtn": ->
    $("#folioPublishConfirm").modal('hide')

  "click #folioUnpublishOkBtn": ->
    $("#folioUnpublishConfirm").modal('hide')
  
  "click #publish": ->
    item = folioItems.findOne({_id: Session.get("editFolioItem")}, {fields: {published: 1}})
    if item.published == true
      folioItems.update({_id: Session.get("editFolioItem")}, {$set: {published: false}})
    else
      folioItems.update({_id: Session.get("editFolioItem")}, {$set: {published: true}})
    
    theDate = new Date
    folioItems.update({_id: Session.get("editFolioItem")}, {$set: {lastUpdated: theDate, lastUpdatedBy: Meteor.userId()}})

  "click #deleteFolioRecord": ->
    console.log "delete"
    folioItems.remove({_id: Session.get("editFolioItem")})
    $("#deleteModal").modal('hide')
    console.log "deleted"
   

