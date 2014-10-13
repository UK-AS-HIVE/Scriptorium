Package.describe({
  summary: "An attempt at creating a message board package",
  version: "0.0.1",
  git: " \* Fill me in! *\ "
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.3.1');
  api.use([
    'session',
    'templating',
    'coffeescript',
    'dburles:collection-helpers@1.0.0',
    'mongo-livedata@1.0.3',
    'mrt:moment'
    ]);
  api.addFiles([
    'client/lib/jquery.timeago.js',
    'client/views/board.html',
    'client/views/board.coffee'
    ], 'client');
  api.addFiles('bruce:messageboard.coffee', ['client', 'server']);
  api.addFiles('server/methods.coffee', 'server');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('bruce:messageboard');
  api.addFiles('bruce:messageboard-tests.js');
});
