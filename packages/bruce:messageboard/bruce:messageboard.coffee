console.log('package code????')
@Messages = new Mongo.Collection('messages')
@Messages.helpers({
  author: () ->
    User.first({_id: @startedBy})

  postCount: () ->
    @posts.length

  onlyOnePost: () ->
    @posts.length == 1

  lastPost: () ->
    if @posts
      _.sortBy(@posts, (p) -> p.timestamp)[0]
})
