@Messages = new Mongo.Collection('messages')

@Messages.forRoom = (roomId) ->
  Messages.find({roomId: roomId}, {sort: {"posts.timestamp": -1}})

@Messages.helpers({
  author: () ->
    User.first({_id: @startedBy})

  postAuthor: (userId) ->
    user = User.first({_id: userId})
    if user then user.fullName() else ""

  postCount: () ->
    @posts.length

  onlyOnePost: () ->
    @posts.length == 1

  lastPost: () ->
    if @posts
      _.sortBy(@posts, (p) -> p.timestamp)[0]
})
