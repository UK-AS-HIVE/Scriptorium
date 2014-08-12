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

Template.folioEdit.languages = ->
  Manuscript.languages

Template.folioEdit.scripts = ->
  Manuscript.scripts

Template.folioEdit.alphabet = ->
  Manuscript.alphabet
