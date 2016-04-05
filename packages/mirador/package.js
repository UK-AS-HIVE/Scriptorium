Package.describe({
  summary: "Mirador v1",
  version: "0.0.1"
});

Package.onUse(function(api) {
  api.use([
    'templating',
    'coffeescript',
    'mongo',
    'underscore',
  ], 'client');
  api.addFiles([
    'lib/jquery-ui.js',
    'lib/jquery-ui.touch-punch.min.js',
    'lib/jquery-ui.dialogextend.coffee',
    'lib/jquery-ui.dialogextend.collapse.coffee',
    'lib/jquery-ui.dialogextend.minimize.coffee',
    'lib/jquery-ui.dialogextend.maximize.coffee',
    'lib/jquery.scrollTo.min.js',
    'lib/openseadragon.js',
    'lib/jquery.tooltipster.min.js',
  ], 'client');
});

