Meteor.users.allow
  update: (userId, doc, fields, modifier) ->
    (doc._id is userId) and _.isEqual(fields, ['lastProjectId'])
