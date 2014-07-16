Template.home.rendered = ->

  #SEO Page Title & Description
  document.title = "My New Meteor App"
  $("<meta>", { name: "description", content: "Page description for My New Meteor App" }).appendTo "head"

  #Add ckedit cdn
  $("<script>", {type: "text/javscript", src: "//cdn.ckeditor.com/4.4.3/full/ckeditor.js"}).appendTo "head"
	
