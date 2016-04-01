Meteor.methods
  addThread: (roomId, subject, message) ->
    Messages.insert
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

  postToThread: (roomId, message) ->
    Messages.update roomId, { $addToSet: { posts: { user: @userId, message: message, timestamp: new Date() } } }

  deletePost: (roomId, post) ->
    if @userId is post.user
      console.log "Deleting forum post:"
      console.log post
      Messages.update roomId, { $pull: { posts: post } }

