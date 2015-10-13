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
  $(".books").sortable(
    items: ":not(.shelf)"
  )
  
  $('.books').sortable().bind 'sortupdate', (e, ui)->
    el = ui.item.get(0)
    elData = Blaze.getData(el)
    before = ui.item.prev().get(0)
    after = ui.item.next().get(0)
    fromId = Blaze.getData(el).bookshelfId
    toId = 0
    #if moving a whole category
    if (elData.category)
      if Blaze.getData(before).category
        beforeId = Blaze.getData(before).category
      else if Blaze.getData(before).bookshelfId
        Blaze.getData(before).bookshelfId
      else


    #If there is a book before the entry
    if Blaze.getData(before).bookshelfId
      toId = Blaze.getData(before).bookshelfId
    #if there is a category before the entry
    else if Blaze.getData(before).category
      toId = Blaze.getData(before)._id
    #moving across categories
    if (toId and fromId != toId)
      Books.update(elData._id, {$set: {bookshelfId: toId}})
    #calculate new rank based on before and after elements
    newRank = 0
    if (!before || Blaze.getData(before).category)
      if Blaze.getData(after).rank
        newRank = Blaze.getData(after).rank - 1 
      else
        newRank = 0;
    else  if (!after || Blaze.getData(after).category)
      if Blaze.getData(before).rank
        newRank = Blaze.getData(before).rank + 1
      else
        newRank = 0;
    else
      newRank = (Blaze.getData(before).rank + Blaze.getData(after).rank)/2
    #update with the new rank
    Books.update(elData._id, {$set: {rank: newRank}})
    #need to reapply sortable to new elements 
    Meteor.setTimeout(->
      $(".books").sortable()
    , 500)
Template.bookshelf.events
  'click .add-category-btn': (e, tmpl)->
    console.log("adding category")
    category = tmpl.find(".category-input").value
    categoryColor = tmpl.find(".category-color-input").value
    id = 1
    categoryCount = Bookshelves.find({project: Session.get("current_project")}).count()
    if (Bookshelves.findOne({category: category, project: Session.get("current_project")}))
      console.log("Category already exists")
      #error
    else
      id = Bookshelves.insert({category: category, project: Session.get("current_project"), color: categoryColor, rank: categoryCount + 1})
      $('#categoryModal').modal('hide')

  'click .edit-category-btn': (e, tmpl) ->
    Session.set("currentCategoryId", @_id)
    Session.set("currentCategoryName", @category)
    Session.set("currentCategoryColor", @color)
    $('#editCategoryModal').modal('show')

  'click .update-category-btn': (e, tmpl) ->
    id = Session.get("currentCategoryId")
    newName = tmpl.find(".edit-category-input").value
    newColor = tmpl.find(".edit-category-color-input").value
    Bookshelves.update(id, {$set: {category: newName, color: newColor}})
    $('#editCategoryModal').modal('hide')

  'click .save-link-btn': (e, tmpl)->
    linkName = tmpl.find(".link-name-input").value
    linkUrl = tmpl.find(".link-url-input").value
    category = tmpl.find(".category-select").value
    bookshelfId = Bookshelves.findOne({project: Session.get("current_project"), category: category})._id
    booksCount = Books.find({bookshelfId: bookshelfId}).count()
    Books.insert({name: linkName, url: linkUrl, bookshelfId: bookshelfId, rank: booksCount + 1})
    $('#linkModal').modal('hide')
    Meteor.setTimeout(->
      $(".books").sortable(
        items: ":not(.shelf)")
    , 500)

  'click .delete-link-btn': (e,tmpl)->
    Books.remove(@_id);

  'click .edit-link-btn': (e, tmpl) ->
    Session.set("linkNameValue", @name)
    Session.set("linkUrlValue", @url)
    Session.set("linkCategoryValue", Bookshelves.findOne(@bookshelfId).category)
    Session.set("editBookId", @_id)
    $('#editLinkModal').modal('show')

  'click .update-link-btn': (e, tmpl)->
    linkName = tmpl.find(".edit-link-name-input").value
    linkUrl = tmpl.find(".edit-link-url-input").value
    bookId = Session.get("editBookId")
    Books.update(bookId, {$set: {name: linkName, url: linkUrl}})
    $('#editLinkModal').modal('hide')



Template.bookshelf.helpers
  bookshelf: ->
    return Bookshelves.find({project: Session.get("current_project")}, {sort: {rank: 1}})
  books: (bookshelfId)->
    return Books.find({bookshelfId: bookshelfId}, {sort: {rank: 1}})
  linkNameValue: ->
    Session.get("linkNameValue")
  linkUrlValue: ->
    Session.get("linkUrlValue")
  linkCategoryValue: ->
    Session.get("linkCategoryValue")
  currentCategoryName: ->
    Session.get("currentCategoryName")
  currentCategoryColor: ->
    Session.get("currentCategoryColor")