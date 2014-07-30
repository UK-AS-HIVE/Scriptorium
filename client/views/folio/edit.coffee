Template.folioEdit.rendered = ->

  #DATE SLIDER
  $("#dateSlider").slider {
    tooltip: 'hide',
    min: 100,
    max: 2025,
    step: 25,
    value: [100,2025]
  }

  $("#dateSlider").on "slide", (slideEvt) ->
    $("#firstDate").text slideEvt.value[0]
    $("#lastDate").text slideEvt.value[1]
    return

  #CK EDITOR
  CKEDITOR.replace('description')
  CKEDITOR.replace('features')
  CKEDITOR.replace('info')
  CKEDITOR.replace('transcription')
