Template.desk.rendered = ->

  #SEO Page Title & Description
  document.title = "Scriptorium - Desk"

  #Add ckedit cdn
  $("<script>", {type: "text/javscript", src: "//cdn.ckeditor.com/4.4.3/full/ckeditor.js"}).appendTo "head"