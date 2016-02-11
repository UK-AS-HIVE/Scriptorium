availableWidgets =
  'imageView': 'Image View'
  'scrollView': 'Scroll View'
  'thumbnailsView': 'Thumbnails View'
  'metadataView': 'Metadata View'
  'editorView': 'Editor'
  'openLayersAnnotoriusView': 'Annotate View'

requiredProperties =
  title: 'function'
  height: 'number'
  width: 'number'



testWidgetProperty = (w, p, t) ->
  Tinytest.add "mirador widget properties - #{w} - #{p}", (test) ->
    test.isNotUndefined miradorWidgetProperties[w][p], "#{w} implements widget property #{p}"
    test.equal typeof(miradorWidgetProperties[w][p]), requiredProperties[p], "#{w} property #{p} is type #{t}"

for w, v of availableWidgets
  for p, t of requiredProperties
    testWidgetProperty w, p, t

