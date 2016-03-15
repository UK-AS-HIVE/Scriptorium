if Npm.require('cluster').isMaster
  handle = null
  FileCabinet.after.update (userId, doc, fieldNames, modifier, options) ->
    if _.contains(fieldNames, 'content')
      if handle then Meteor.clearTimeout(handle)
      handle = Meteor.setTimeout ->
        FileCabinet.update doc._id, { $set: { editorLockedBy: null } }
      , 30000
      FileCabinet.update doc._id, { $set: { editorLockedBy: userId } }

