describe 'Basic Scriptorium functionality', ->
  s = meteor()
  c1 = browser(s)
  #c2 = browser(s)

  before ->
    # Initialize everything
    s.execute ->
      RequestedAccounts.insert
        email: 'scribe@scriptorium.net'
        firstName: 'scribe'
        lastName: 'scribe'
        research: 'scribing'
        approved: true
      Accounts.createUser
        username: 'scribe'
        password: 'scribe'
        email: 'scribe@scriptorium.net'
      #Accounts.createUser
      #  username: 'monk'
      #  password: 'monk'
      #  email: 'monk@scriptorium.net'
    .then ->
      c1.execute ->
        Meteor.loginWithPassword 'scribe', 'scribe'
      #c2.execute ->
      #  Meteor.loginWithPassword 'monk', 'monk'

  it 'should see links to desk, file cabinet, etc.', ->
    c1.expectTextToContain 'header div.bottom .pull-left', 'Desk'
    c1.expectTextToContain 'header div.bottom .pull-left', 'File Cabinet'
    c1.expectTextToContain 'header div.bottom .pull-left', 'Bookshelf'
    c1.expectTextToContain 'header div.bottom .pull-left', 'Collaboration'
    c1.expectTextToContain 'header div.bottom .pull-left', 'Folio Manager'

    c1.execute ->
      $('header a:contains(Desk)').click()
    .then ->
      c1.waitForRoute '/desk'
      c1.execute ->
        $('a:contains(Load Manuscript)').click()

