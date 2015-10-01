Template.bookshelf.rendered = ->


  # CONTRAST SHELF COLOR
  isDark = (color) ->
    match = /rgb\((\d+).*?(\d+).*?(\d+)\)/.exec(color)
    parseFloat(match[1]) + parseFloat(match[2]) + parseFloat(match[3]) < 3 * 256 / 2 # r+g+b should be less than half of max (3 * 256)


  $(".shelf").each ->
    $(this).find('a').css "color", (if isDark($(this).css("background-color")) then "#fff" else "#000")
    $(this).css "color", (if isDark($(this).css("background-color")) then "white" else "black")
    return

  # SETUP COLOR PICKER
  $ ->
    $(".color-picker").colorpicker()
    return

  # SORTABLE
  $(".books").sortable
    items: ":not(.shelf)"


Template.bookshelf.events
  'click .save-link-btn': (e, tmpl)->
    linkName = tmpl.find(".link-name-input").value
    linkUrl = tmpl.find(".link-url-input").value
    category = tmpl.find(".category-select").value
    id = Bookshelves.findOne({project: Session.get("current_project"), category: category})._id
    #TODO Need to make sure item not in...
    Bookshelves.update(id, { $push: { items: {user: Meteor.userId(), linkName: linkName, linkUrl: linkUrl}}})
    if (id)
      $('#linkModal').modal('hide')

  'click .add-category-btn': (e, tmpl)->
    console.log("adding category")
    category = tmpl.find(".category-input").value
    categoryColor = tmpl.find(".category-color-input").value
    id = 0
    if (Bookshelves.findOne({category: category, project: Session.get("current_project")}))
      console.log("Category already exists")
      #error
    else
      id = Bookshelves.insert({category: category, project: Session.get("current_project"), color: categoryColor})

      $('#categoryModal').modal('hide')


Template.bookshelf.helpers
  bookshelf: ->
    return Bookshelves.find({project: Session.get("current_project")})