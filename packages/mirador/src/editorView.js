(function($) {

  $.EditorView = function(options) {

    jQuery.extend(this, {
      currentImg:           null,
      element:              null,
      parent:               null,
      metadata:             null,
      editorID:             null, 
      //metadataListingCls:   'metadata-listing',
      navToolbarCls:        'mirador-editor-view-nav-toolbar'
    }, options);

    //this.metadata = $.getMetadataByManifestId(this.manifestId);
  };


  $.EditorView.prototype = {

    render: function() {
      var _this = this,
          types = [ 'about', 'details', 'rights', 'links', 'metadata' ];

      // jQuery.each(types, function(index, type) {
      //   tplData[type] = [];

      //   // alert(type + ' ' + _this.metadata[type]);
      //   jQuery.each(_this.metadata[type], function(key, value) {
      //     if (typeof value === 'object') {
      //       value = $.stringifyObject(value);
      //     }

      //     if (typeof value === 'string' && value !== '') {
      //       tplData[type].push({
      //         label: $.extractLabelFromAttribute(key),
      //         value: _this.addLinksToUris(value)
      //       });

      //     }
      //   });
      // });

      

      this.addEditorWindow();
      this.addToolbarNav();
      this.attachEvents();
      
    },


    addToolbarNav: function() {
      this.parent.toolbar.append($.Templates.editorView.navToolbar({
        navToolbarCls: this.navToolbarCls
      }));
    },


    attachEvents: function() {
      var navToolbar = this.parent.toolbar.element.find('.' + this.navToolbarCls),
          selectorScrollView     = '.mirador-icon-scroll-view',
          selectorThumbnailsView = '.mirador-icon-thumbnails-view',
          selectorSave           = '.mirador-icon-load-editor',
          _this = this;

      navToolbar.on('click', selectorScrollView, function() {
        $.viewer.loadView("scrollView", _this.manifestId);
      });

      navToolbar.on('click', selectorThumbnailsView, function() {
        $.viewer.loadView("thumbnailsView", _this.manifestId);
      });

      navToolbar.on('click', selectorSave, function(){
        Meteor.call('saveEditorDoc', CKEDITOR.instances.myEditor.getData());
      });
    },

    addEditorWindow: function(){
      var that = this;
      Meteor.call('getNewEditorID', function(error, newEditorID){
        console.log(newEditorID);
        that.element.append($.Templates.editorView.showTextArea({editorID: newEditorID}));
        that.replaceEditor(newEditorID);
      });        

    },

    replaceEditor: function(editorID){
      CKEDITOR.replace(editorID);
    }





  };


}(Mirador));