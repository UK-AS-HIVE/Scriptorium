Package.describe({
  summary: "Mirador v1",
  version: "0.0.1"
});

Package.onUse(function(api) {
  api.use([
    'templating',
    'coffeescript',
    'mongo'
  ], 'client');
  api.addFiles([
    'lib/jquery-ui-no-slider.custom.js',
    // 'lib/jquery-ui.custom.min.js',
    //'lib/jquery-ui.min.js',
    'lib/jquery-ui.touch-punch.min.js',
    'lib/jquery-ui.dialogextend.min.js',
    'lib/jquery.scrollTo.min.js',
    'lib/handlebars.js',
    'lib/openseadragon.min.js',
    'lib/jquery.tooltipster.min.js',
    'lib/d3.v3.min.js',
    'lib/uri.min.js',
    'lib/OpenLayers.js',
    'lib/annotorious.min.js',
    'lib/anno-parse-plugin.js',
  ], 'client');

  api.addFiles([
    'src/mirador.js',
    'src/helpers.js',
    'src/manifestsLoader.js',
    'src/viewer.js',
    //'src/templates.js',
    //'src/mainMenuWindowOptions.js',
    //'src/mainMenuLoadWindow.js',
    //'src/mainMenu.js',
    //'src/statusBar.js',
    'src/layout.js',
    'src/manifest.js',
    'src/AnnotationsLayer.js',
    'src/widget.js',
    //'src/widgetToolbar.js',
    'src/lockController.js',
    'src/iiif.js',
    'src/imageView.js',
    'src/scrollView.js',
    'src/metadataView.js',
    'src/editorView.js',
    'src/thumbnailsView.js',
    'src/openLayersAnnotoriusView.js',
    //'src/widgetStatusBar.js',
    //'src/widgetContent.js',
    'src/openSeadragon.js',
    'src/scale.js',
    'src/settingsLoader.js',
    'src/saveController.js',
    'src/annotationBottomPanel.js',
    'src/annotationLayerRegionController.js',
    'src/annotationListing.js',
    'src/annotationSidePanel.js'
  ], 'client');

  api.addFiles([
    'src/mirador.html',
    'src/mirador.coffee',
    'src/mainMenu.html',
    'src/mainMenu.coffee',
    'src/viewer.html',
    'src/viewer.coffee',
    'src/widget.html',
    'src/widget.coffee',
    'src/imageView.html',
    'src/imageView.coffee',

    'src/editorView.html',
    'src/metadataView.html',
    'src/openLayersAnnotoriusView.html',
    'src/scrollView.html',
    'src/statusBar.html',
    'src/thumbnailsView.html'
  ], 'client');
});

