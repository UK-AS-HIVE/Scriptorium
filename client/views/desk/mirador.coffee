Template.mirador.rendered = ->
	#Add ckedit cdn
  $("<script>", {type: "text/javscript", src: "//cdn.ckeditor.com/4.4.3/full/ckeditor.js"}).appendTo "head"