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
