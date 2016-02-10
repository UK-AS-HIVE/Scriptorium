Template.mbThread.rendered = ->
  @.autorun ->
    currentProject = Session.get('current_project')
    data = Router.current().data()

    if currentProject && data && data.roomId != currentProject
      Router.go('collaboration')

Template.mbThread.helpers
  oldestFirst: () ->
    !Session.get('mbSortThreadAsc')

  newestFirst: () ->
    Session.get('mbSortThreadAsc')

Template.mbThread.events
  'click .reply button': (e, t) ->
    e.preventDefault()
    textarea = t.$('.reply textarea')
    message = textarea.val()
    Meteor.call('postToThread', @_id, message)
    textarea.val('')

  'change .sort-by select': (e, t) ->
    e.preventDefault()
    Session.set('mbSortThreadAsc', t.$('select').val() == "true")

Template.mbPosts.helpers
  breaklines: (text) ->
    if text
      t = text.trim()
      '<p>'+t.replace(/[\r\n]+/g,'</p><p>')+'</p>'

  posts: ->
    posts = _.sortBy(@posts, (p) -> p.timestamp)

    if Session.get('mbSortThreadAsc')
      posts.reverse()
    else
      posts
