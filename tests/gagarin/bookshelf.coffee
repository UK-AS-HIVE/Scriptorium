describe 'Bookshelf', ->
  s = meteor()
  c1 = browser(s)
  c2 = browser(s)

  initServer = ->
    # Initialize everything
    s.execute ->
      RequestedAccounts.insert
        email: 'scribe@scriptorium.net'
        firstName: 'scribe'
        lastName: 'scribe'
        research: 'scribing'
        approved: true
      RequestedAccounts.insert
        email: 'monk@scriptorium.net'
        firstName: 'monk'
        lastName: 'monk'
        research: 'monking'
        approved: true

      scribeUserId = Accounts.createUser
        username: 'scribe'
        password: 'scribe'
        email: 'scribe@scriptorium.net'
      monkUserId = Accounts.createUser
        username: 'monk'
        password: 'monk'
        email: 'monk@scriptorium.net'

      projectId = Projects.insert
        projectName: 'Monk + Scribe'
        permissions: [
          {user: scribeUserId, level: 'admin'},
          {user: monkUserId, level: 'admin'}
        ]
        miradorData: []

      bookshelfId = Bookshelves.insert
        category: 'Books'
        project: projectId
        color: '#000000'
        rank: 1

      Books.insert
        name: 'CCL'
        url: 'http://ccl.rch.uky.edu/'
        bookshelfId: bookshelfId
        rank: 2

      Books.insert
        name: 'A&S'
        url: 'http://www.as.uky.edu/'
        bookshelfId: bookshelfId
        rank: 3

  makeClientLoggedInAndGoToBookShelf = (c, username, password, makeDone) ->
    if username == 'monk'
      login = c.execute ->
        Meteor.loginWithPassword 'monk', 'monk'
    else
      login = c.execute ->
        Meteor.loginWithPassword 'scribe', 'scribe'
    login.then ->
      c.expectTextToContain 'header div.bottom .pull-left', 'Desk'
      c.expectTextToContain 'header div.bottom .pull-left', 'File Cabinet'
      c.expectTextToContain 'header div.bottom .pull-left', 'Bookshelf'
      c.expectTextToContain 'header div.bottom .pull-left', 'Collaboration'
      c.expectTextToContain 'header div.bottom .pull-left', 'Folio Manager'

      c.execute ->
        Tracker.autorun ->
          if p = Projects.findOne({name: 'Monk + Scribe'})?._id
            Session.set 'current_project', p
        $('header a:contains(Bookshelf)').click()
      .then ->
        c.waitForRoute '/bookshelf'

  before ->
    initServer().then ->
      makeClientLoggedInAndGoToBookShelf(c1, 'scribe', 'scribe')
      makeClientLoggedInAndGoToBookShelf(c2, 'monk', 'monk')

  it 'displays bookshelf and books', ->
    c1.waitForDOM('.bookshelf .shelf', 5000).then ->
      c1.expectTextToContain '.bookshelf .shelf', 'Books'
      c1.execute ->
        expect($('.bookshelf .book:first').text().trim()).to.equal 'CCL'
        expect($('.bookshelf .book:last').text().trim()).to.equal 'A&S'

