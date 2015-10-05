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
  @$(".books").sortable
    items: ":not(.shelf)"


Template.bookshelf.events
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
    id = Bookshelves.findOne({project: Session.get("current_project"), category: category})._id

    Bookshelves.update(id, { $push: { items: {linkName: linkName, linkUrl: linkUrl}}})
    if (id)
      $('#linkModal').modal('hide')

  'click .delete-link-btn': (e,tmpl)->
    parentId = e.target.getAttribute("parentId")
    Bookshelves.update(parentId, {$pull: {items: @}})

  'click .edit-link-btn': (e, tmpl) ->
    parentId = e.target.getAttribute("parentId")
    Session.set("linkNameValue", @linkName)
    Session.set("linkUrlValue", @linkUrl)
    Session.set("linkCategoryValue", Bookshelves.findOne(parentId).category)
    Session.set("linkParentId", parentId)
    $('#editLinkModal').modal('show')

  'click .save-edit-link-btn': (e, tmpl)->
    parentId = Session.get("linkParentId")
    linkName = tmpl.find(".edit-link-name-input").value
    linkUrl = tmpl.find(".edit-link-url-input").value
    item = {user: Meteor.userId(), linkName: Session.get("linkNameValue"), linkUrl: Session.get("linkUrlValue")}
    Bookshelves.update(parentId, { $pop: { items: {linkName: linkName, linkUrl: linkUrl}}})
    Bookshelves.update(parentId, { $push: { items: {linkName: linkName, linkUrl: linkUrl}}})
    $('#editLinkModal').modal('hide')



Template.bookshelf.helpers
  bookshelf: ->
    return Bookshelves.find({project: Session.get("current_project")})
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
