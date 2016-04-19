hexToRgb = (hex) ->
  shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i
  hex = hex.replace shorthandRegex, (m, r, g, b) ->
    r + r + g + g + b + b

  result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
  return [
      parseInt(result[1], 16)
      parseInt(result[2], 16)
      parseInt(result[3], 16)
  ]

Template.bookshelf.rendered = ->
  @autorun =>
    if Bookshelves.find({project: Session.get("current_project")})
      enableSortable.call @

Template.bookshelf.events
  'click [data-toggle=modal]': (e, tpl) ->
    modal = tpl.$(e.currentTarget).data('modal')
    Blaze.renderWithData Template[modal], @, $('body').get(0)
    $("##{modal}").modal('show')

Template.bookshelf.helpers
  foregroundColor: ->
    rgb = hexToRgb @color
    if parseFloat(rgb[0]) + parseFloat(rgb[1]) + parseFloat(rgb[2]) < 3 * 256 / 2 # r+g+b should be less than half of max (3 * 256)
      "#fff"
    else
      "#000"

  bookshelf: ->
    enableSortable()
    Bookshelves.find { project: Session.get("current_project") }, { sort: { rank: 1 } }
  books: ->
    Books.find { bookshelfId: @_id }, { sort: { rank: 1 } }
  fileUrl: ->
    @url or "file/" + FileRegistry.findOne(@fileRegistryId).filenameOnDisk


enableSortable = ->
  tpl = @
  tpl.$('.books').sortable().sortable
    cancel: '.shelf',
    stop: (e, ui)->
      el = ui.item.get(0)
      elData = Blaze.getData(el)

      before = ui.item.prev().get(0)
      if !before
        tpl.$(this).sortable('cancel')
        return

      beforeData = Blaze.getData(before)
      after = ui.item.next().get(0)
      if after then afterData = Blaze.getData(after)

      newRank = 0
      if elData
        fromId = toId = elData.bookshelfId

        # If there is a book before the entry
        if beforeData.bookshelfId
          toId = beforeData.bookshelfId

        # if there is a category before the entry
        else if beforeData.category
          toId = beforeData._id

        #calculate new rank based on before and after elements
        if (!before || beforeData.category) && afterData
          unless afterData.category then newRank = afterData.rank - 1

        else if (!after || afterData.category)
          unless beforeData.category then newRank = beforeData.rank + 1

        else
          newRank = (beforeData.rank + afterData.rank)/2
        # Update new rank
        Books.update elData._id, { $set: { bookshelfId: toId, rank: newRank } }

  tpl.$('.shelf').disableSelection()
