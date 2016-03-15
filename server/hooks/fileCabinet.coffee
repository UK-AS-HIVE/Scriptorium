if Npm.require('cluster').isMaster
  handles = {}
  FileCabinet.after.update (userId, doc, fieldNames, modifier, options) ->
    if _.contains(fieldNames, 'content')
      if handles[doc._id] then Meteor.clearTimeout(handles[doc._id])
      handles[doc._id] = Meteor.setTimeout ->
        FileCabinet.update doc._id, { $set: { editorLockedBy: null } }
      , 30000
      FileCabinet.update doc._id, { $set: { editorLockedBy: userId } }

