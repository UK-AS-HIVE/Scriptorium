(function($) {

  $.MainMenuLoadWindow = function(options) {

    jQuery.extend(true, this, {
      element:                null,
      width:                  300,
      collectionsListingCls:  'mirador-listing-collections'
    }, options);

    this.element  = this.element || jQuery('<div/>');
    this.removeEvents();
    this.attachEvents();
  };


  $.MainMenuLoadWindow.prototype = {

    // load window event handlers
    attachEvents: function() {
      var selectorListing         = '.' + this.collectionsListingCls,
          selectorSelect          = selectorListing + ' select',
          selectorUl              = selectorListing + ' ul',
          selectorScrollView      = selectorListing + ' a.mirador-icon-scroll-view',
          selectorMetadataView    = selectorListing + ' a.mirador-icon-metadata-view',
          selectorThumbnailsView  = selectorListing + ' a.mirador-icon-thumbnails-view',
          selectorAddMani         = selectorListing + ' a.mirador-icon-add-mani',
          _this                   = this;

      // attach onChange event handler for collections select list
      jQuery(document).on('change', selectorSelect, function() {
        var manifestId = jQuery(this).find('option:selected').data('manifest-id');

        jQuery(selectorUl).hide();
        jQuery(selectorUl + '.ul-' + manifestId).show();
      });

      // attach click event handler for images in the list
      jQuery(document).on('click', selectorUl, function(event) {
        var elemTarget = jQuery(event.target),
            manifestId,
            imageId,
            openAt;

        manifestId = elemTarget.data('manifest-id');
        imageId = elemTarget.data('image-id');

        // TODO: This should be configurable
        $.viewer.loadView("imageView", manifestId, imageId);
      });

      // attach click event for thumbnails view icon
      jQuery(document).on('click', selectorThumbnailsView, function() {
        var manifestId = jQuery(selectorSelect).find('option:selected').data('manifest-id');

        $.viewer.loadView("thumbnailsView", manifestId);
      });

      jQuery(document).on('click', selectorAddMani, function() {
        // Meteor.miradorFunctions.addMani();
        console.log("load manifest");
      });      

      // attach click event for scroll view icon
      jQuery(document).on('click', selectorScrollView, function() {
        var manifestId = jQuery(selectorSelect).find('option:selected').data('manifest-id');

        $.viewer.loadView("scrollView", manifestId);
      });

      // attach click event for metadata view icon
      jQuery(document).on('click', selectorMetadataView, function() {
        var manifestId = jQuery(selectorSelect).find('option:selected').data('manifest-id');

        $.viewer.loadView("metadataView", manifestId);
      });
    },

    removeEvents: function(){
      var selectorListing         = '.' + this.collectionsListingCls,
          selectorSelect          = selectorListing + ' select',
          selectorUl              = selectorListing + ' ul',
          selectorScrollView      = selectorListing + ' a.mirador-icon-scroll-view',
          selectorMetadataView    = selectorListing + ' a.mirador-icon-metadata-view',
          selectorThumbnailsView  = selectorListing + ' a.mirador-icon-thumbnails-view',
          selectorAddMani         = selectorListing + ' a.mirador-icon-add-mani',
          _this                   = this;

      jQuery(document).off('click', selectorUl);
      jQuery(document).off('click', selectorThumbnailsView);
      jQuery(document).off('click', selectorScrollView);
      jQuery(document).off('click', selectorMetadataView);

    }


  };



}(Mirador));
