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
  paragraphs: ->
    @message.split('\n')

  linkify: (text) ->
    text = escape(text)

    urlPattern = /(\b(https?|ftp):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/gim
    pseudoUrlPattern = /(^|[^\/])(www\.[-A-Z0-9+&@#\/%=~_|.]*[-A-Z0-9+&@#\/%=~_|])/gim
    emailAddressPattern = /[\w.]+@[a-zA-Z_-]+?(?:\.[a-zA-Z]{2,6})+/gim

    replacedText = text
              .replace(urlPattern, '<a href="$&" target="_blank">$&</a>')
              .replace(pseudoUrlPattern, '$1<a href="http://$2" target="_blank">$2</a>')
              .replace(emailAddressPattern, '<a href="mailto:$&">$&</a>')
   
    return Spacebars.SafeString replacedText

  posts: ->
    posts = _.sortBy(@posts, (p) -> p.timestamp)

    if Session.get('mbSortThreadAsc')
      posts.reverse()
    else
      posts


escape = (str) ->
  str.replace(/&/g, '&amp;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#x27;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/\`/g, '&#96;')
