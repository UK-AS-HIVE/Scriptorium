Meteor.methods({
  addThread: (roomId, subject, message) ->
    Messages.insert({
        subject: subject,
        roomId: roomId,
        startedBy: @userId
        posts: [
          {
            user: @userId,
            message: message,
            timestamp: new Date()
          }
        ]
    })

  postToThread: (roomId, message) ->
    Messages.update({_id: roomId},
                    {$addToSet: {
                      posts: {
                        user: @userId,
                        message: message,
                        timestamp: new Date()
                      }
                    }})
})
