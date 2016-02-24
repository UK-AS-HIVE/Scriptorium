### ADD LINK MODAL###
Template.addLinkModal.events
  'click button[data-action=saveLink]': (e, tpl)->
    linkName = tpl.$('input[name=linkName]').val()
    linkUrl = tpl.$('input[name=linkUrl]').val()
    category = tpl.$("select[name=category]").val()
    bookshelfId = Bookshelves.findOne({ project: Session.get("current_project"), category: category})._id
    booksCount = Books.find({bookshelfId: bookshelfId}).count()
    Books.insert
      name: linkName
      url: linkUrl
      bookshelfId: bookshelfId
      rank: booksCount + 1

    tpl.$('#addLinkModal').modal('hide')

  'hidden.bs.modal': (e, tpl) ->
    Blaze.remove tpl.view

Template.addLinkModal.helpers
  bookshelf: ->
    Bookshelves.find { project: Session.get("current_project") }, { sort: { rank: 1 } }

### EDIT LINK MODAL ###
Template.editLinkModal.events
  'click button[data-action=saveLink]': (e, tpl) ->
    linkName = tpl.$('input[name=linkName]').val()
    linkUrl = tpl.$('input[name=linkUrl]').val()
    Books.update @_id, { $set: { name: linkName, url: linkUrl } }
    tpl.$('#editLinkModal').modal('hide')

  'hidden.bs.modal': (e, tpl) ->
    Blaze.remove tpl.view

### DELETE LINK MODAL ###
Template.deleteLinkModal.events
  'click [data-action=deleteLink]': (e, tpl) ->
    Books.remove @_id
    tpl.$('#deleteLinkModal').modal('hide')

  'hidden.bs.modal': (e, tpl) ->
    Blaze.remove tpl.view

### NEW CATEGORY MODAL ###
Template.newCategoryModal.onCreated ->
  @error = new ReactiveVar ""
Template.newCategoryModal.onRendered ->
  @.$('.color-picker').colorpicker()

Template.newCategoryModal.helpers
  error: -> Template.instance().error.get()

Template.newCategoryModal.events
  'click button[data-action=addCategory]': (e, tpl) ->
    category = tpl.$('input[name=categoryName]').val()
    categoryColor = tpl.$('input[name=categoryColor]').val()
    categoryCount = Bookshelves.find({ project: Session.get("current_project") }).count()

    if (Bookshelves.findOne({category: category, project: Session.get("current_project")}))
      tpl.error.set "A category with that name already exists."
    else
      Bookshelves.insert
        category: category
        project: Session.get("current_project")
        color: categoryColor
        rank: categoryCount + 1

      tpl.$('#newCategoryModal').modal('hide')

  'hidden.bs.modal': (e, tpl) ->
    Blaze.remove tpl.view

### EDIT CATEGORY MODAL ###
Template.editCategoryModal.onCreated ->
  @error = new ReactiveVar ""
Template.editCategoryModal.onRendered ->
  @.$('.color-picker').colorpicker()
Template.editCategoryModal.helpers
  error: -> Template.instance().error.get()

Template.editCategoryModal.events
  'click button[data-action=updateCategory]': (e, tpl) ->
    newName = tpl.$('input[name=categoryName]').val()
    newColor = tpl.$('input[name=categoryColor]').val()
    if (Bookshelves.findOne({_id: { $ne: @_id }, category: newName, project: Session.get("current_project")}))
      tpl.error.set "A category with that name already exists."
    else
      Bookshelves.update @_id, { $set: { category: newName, color: newColor } }
      tpl.$('#editCategoryModal').modal('hide')

  'hidden.bs.modal': (e, tpl) ->
    Blaze.remove tpl.view

### UPLOAD PDF MODAL ###
Template.uploadPdfModal.onCreated ->
  @uploadedFileId = new ReactiveVar
Template.uploadPdfModal.events
  'click button[data-action=uploadFile]': (e, tpl) ->
    Media.pickLocalFile {multiple: false, accept: '.pdf'}, (fileId) ->
      fileName = FileRegistry.findOne({"_id": fileId})
      tpl.uploadedFileId.set fileId

  'click button[data-action=saveFile]': (e, tpl)->
    file = FileRegistry.findOne tpl.uploadedFileId.get()
    category = tpl.$('select[name=category]').val()
    bookshelfId = Bookshelves.findOne({project: Session.get("current_project"), category: category})._id
    booksCount = Books.find({bookshelfId: bookshelfId}).count()
    Books.insert({name: file.filename, fileRegistryId: file._id, bookshelfId: bookshelfId, rank: booksCount + 1})
    tpl.$('#uploadPdfModal').modal('hide')

  'hidden.bs.modal': (e, tpl) ->
    Blaze.remove tpl.view

Template.uploadPdfModal.helpers
  bookshelf: ->
    Bookshelves.find { project: Session.get("current_project") }, { sort: { rank: 1 } }
  filename: ->
    FileRegistry.findOne({ _id: Template.instance().uploadedFileId.get() })?.filename
  disabled: ->
    unless Template.instance().uploadedFileId.get() then "disabled"

