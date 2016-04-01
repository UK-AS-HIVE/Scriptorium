Template.mbThread.rendered = ->
  @.autorun ->
    currentProject = Session.get('current_project')
    data = Router.current().data()

    if currentProject && data && data.roomId != currentProject
      Router.go('collaboration')

Template.mbThread.helpers
  oldestFirst: ->
    !Session.get('mbSortThreadAsc')

  newestFirst: ->
    Session.get('mbSortThreadAsc')

  posts: ->
    posts = _.sortBy(@posts, (p) -> p.timestamp)

    if Session.get('mbSortThreadAsc')
      posts.reverse()
    else
      posts

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


Template.mbPost.helpers
  deleting: ->
    Template.instance().deleting.get()
  userIsAuthor: ->
    @user is Meteor.userId()
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

Template.mbPost.events
  'click a[data-action=deletePost]': (e, tpl) ->
    tpl.deleting.set true
  'click a[data-action=cancelDelete]': (e, tpl) ->
    tpl.deleting.set false
  'click a[data-action=confirmDelete]': (e, tpl) ->
    Meteor.call 'deletePost', Template.parentData(1)._id, @
    tpl.deleting.set false

Template.mbPost.onCreated ->
  @deleting = new ReactiveVar false

escape = (str) ->
  str.replace(/&/g, '&amp;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#x27;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/\`/g, '&#96;')
