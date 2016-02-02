(function($){

  $.Templates = {

    /* Main menu
    ---------------------------------------------------------------------------- */
    mainMenu: {
      // template for rendering main menu at the top
      menuItems: Handlebars.compile([
        '<ul class="{{mainMenuCls}}">',
          '<li>',
            '<a href="javascript:;" class="bookmark-workspace" title="Bookmark Workspace">',
              '<span class="icon-bookmark-workspace"></span>Bookmark Workspace',
            '</a>',
          '</li>',
          '<li>',
            '<a href="javascript:;" class="load-window" title="Load Window">',
              '<span class="icon-load-window"></span>Load Window',
            '</a>',
          '</li>',
          '<li>',
            '<a href="javascript:;" class="window-options" title="Window Options">',
              '<span class="icon-window-options"></span>Window Options',
            '</a>',
          '</li>',
          '<li>',
            '<a href="javascript:;" class="clear-local-storage" title="Clear saved workspace and reload">',
              '<span class="icon-clear-local-storage"></span>',
            '</a>',
          '</li>',

        '</ul>'
      ].join('')),

      // template for rendering window options menu
      windowOptionsMenu: Handlebars.compile([
        '<ul class="{{windowOptionsMenuCls}}">',
          '<li><a class="cascade-all" href="javascript:;">Cascade All</a></li>',
          '<li><a class="tile-all-vertically" href="javascript:;">Tile All Vertically</li>',
          '<li><a class="tile-all-horizontally" href="javascript:;">Tile All Horizontally</a></li>',
          '<li><a class="stack-all-vertically-2-cols" href="javascript:;">Stack Vertically (2 columns)</a></li>',
          '<li><a class="stack-all-vertically-3-cols" href="javascript:;">Stack Vertically (3 columns)</a></li>',
          '<li class="ui-state-disabled"><a href="javascript:;">Open Recent</a></li>',
          '<li><a class="close-all" href="javascript:;">Close All</a></li>',
        '</ul>'
      ].join('')),

      // template for rendering load window's manuscripts' select box and images list
      loadWindowContent: Handlebars.compile([
        '<fieldset class="{{cssCls}}">',
          '<legend>Available/Loaded manuscripts</legend>',
          '<select>',
            '{{#collections}}',
              '<optgroup label="{{location}}">',
                '{{#list}}',
                  '<option data-manifest-id="{{manifestId}}">{{collectionTitle}}</option>',
                '{{/list}}',
              '</optgroup>',
            '{{/collections}}',
          '</select><br/>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-thumbnails-view"></a>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-scroll-view"></a>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-metadata-view"></a>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-add-mani"><i class="fa fa-plus" data-toggle="modal" data-target="#addManifestModal"></i></a>',
          '{{#collections}}',
            '{{#list}}',
              '<ul class="ul-{{manifestId}}">',
                '{{#imageData}}',
                  '<li class="load-window-li"><a href="javascript:;" data-image-id="{{id}}" data-manifest-id="{{../manifestId}}">{{trimTitlePrefix title}}</a></li>',
                '{{/imageData}}',
              '</ul>',
            '{{/list}}',
          '{{/collections}}',
        '</fieldset>'
      ].join('')),

      // template for rendering clear local storage dialog
      clearLocalStorage: Handlebars.compile([
        '<div class="{{cssCls}}">',
          '<p>Do you want to delete your saved workspace, and reload the viewer?</p>',
          '<p>',
            '<a class="btn-cancel" href="javascript: jQuery(\'{{selectorClearLocalStorage}}\').tooltipster(\'hide\');">Cancel</a>',
            '<a class="btn-clear" href="javascript: localStorage.clear(); location.reload();">Clear</a>',
          '</p>',
        '</div>'
      ].join(''))

    },

    /* Status bar
    ---------------------------------------------------------------------------- */
    statusBar: {
      textFrames: Handlebars.compile([
        '<div class="mirador-status-bar-msg-left"></div>',
        '<div class="mirador-status-bar-msg-right"></div>'
      ].join(''))
    },


    /* Widget
    ---------------------------------------------------------------------------- */
    widget: {
      // template for rendering widget with placeholders for toolbar and status bar
      initialLayout: Handlebars.compile([
        '<div class="{{widgetToolbarCls}}"></div>',
        '<div class="{{widgetContentCls}}">Loading...</div>',
        '<div class="{{widgetStatusBarCls}}"></div>'
      ].join(''))
    },


    /* Image view
    ---------------------------------------------------------------------------- */
    imageView: {
      // template for rendering tool bar with nav links
      navToolbar: Handlebars.compile([
        '<div class="{{navToolbarCls}}">',
          '<a href="javascript:;" class="mirador-btn mirador-icon-annotations"><i class="fa fa-comments"></i></a>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-choices"></a>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-metadata-view"></a>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-scroll-view"></a>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-thumbnails-view"></a>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-previous"></a>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-next"></a>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-annotorius"></a>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-load-editor"></a>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-send-folio"><i class="fa fa-paper-plane"></i></a>',
        '</div>'
      ].join('')),

      statusbar: Handlebars.compile([
        '<div class="{{statusbarCls}}">',
          '<a href="javascript:;" class="mirador-btn mirador-icon-lock"></a>',
          '<div class="mirador-image-dimensions">',
          '<span class="noDimensionsWarning">No Dimensions Given</span>',
            '<textarea rows="1" class="mirador-image-view-physical-dimensions x">{{width}}</textarea>',
            '<span>✕</span>',
            '<textarea rows="1" class="mirador-image-view-physical-dimensions y">{{height}}</textarea>',
            '<span class="units">mm',
              '<select class="unit-selector">',
                '<option value="mm">millimeters</option>',
                '<option value="cm">centimeters</option>',
                '<option value="m">meters</option>',
              '</select>',
            '</span>',
          '</div>',
        '</div>'
      ].join('')),

      annotationPanel: Handlebars.compile([
        '<div class="annotationListPanel">',
        '<div class="resizeGrip"></div>',
        '{{> annotationStats}}',
          '<ul class="annotationList">',
          '{{#each annotations}}',
            '{{> annotationListing}}',
          '{{/each}}',
          '</ul>',
        '</div>'
      ].join('')),

      annotationStats: (function() {
        var templateString =
        ['<div class="annotationPanelHeader">',
          '<h4>Annotation List (<span class="annotationsTotal">{{annotationCount}}</span>)</h4>',
          '<div class="annoSearch">',
          '<select id="annotationTypeSelector" name="annotationTypes">',
            '<option value="">All (<span class="annotationCount">{{annotationCount}}</span>)</option>',
            '<option value="commenting">Commentary (<span class="imageAnnotationCount">{{imageAnnotationCount}}</span>)</option>',
            '<option value="painting">Transcription (<span class="textAnnotationCount">{{textAnnotationCount}}</span>)</option>',
          '</select>',
          '</div>',
        '</div>'
        ].join('');
        Handlebars.registerPartial('annotationStats', templateString);
        return Handlebars.compile(templateString);
      })(),

      noAnnotationMessage: (function() {
        var templateString =
        ['<div class="annotationPanelHeader">',
            '<h4>No Annotations Provided</h4>',
         '</div>'
        ].join('');
        Handlebars.registerPartial('annotationStats', templateString);
        return Handlebars.compile(templateString);
      })(),

      annotationListing: (function() {
        var templateString =
          ['<li id="listing_{{id}}" class="annotationListing">',
              '{{#if title}}',
              '<h3>{{{title}}}</h3>',
              '{{/if}}',
              '<p>{{{content}}}</p>',
          '</li>'
        ].join('');
        Handlebars.registerPartial('annotationListing', templateString);
        return Handlebars.compile(templateString);
      })(),

      annotationDetail: Handlebars.compile([
        '<div class="annotationDetails">',
          '<div class="annotationNumber">{{annotationNumber}}</div>',
          '<a class="annotationDetailToggle mirador-icon-annotationDetail-toggle" title="Hide this detail panel."><i class="icon-eye-close"></i></a>',
          '<p>{{{body}}}</p>',
        '</div>'
      ].join('')),

      annotationDetailToggle: Handlebars.compile([
        '<div class="displayBottomPanelButton">',
          '<a class="annotationDetailToggle mirador-icon-annotationDetail-toggle" title="Display annotation details in bottom panel."><i class="icon-eye-open"></i></a>',
        '</div>'
      ].join('')),

      imageChoices: Handlebars.compile([
        '<ul class="mirador-image-view-choices">',
          '{{#choicesInfo}}',
            '<li><a href="javascript:;" class="mirador-image-view-choice" data-choice="{{label}}" data-image-url="{{imageUrl}}">{{label}}</a></li>',
          '{{/choicesInfo}}',
        '</ul>'
      ].join(''))

    },


    /* Scroll view
    ---------------------------------------------------------------------------- */
    scrollView: {
      // template for rendering frame for hosting images
      imagesFrame: Handlebars.compile([
        '<div class="{{frameCls}}"></div>'
      ].join('')),

      // template for rendering images in scroll view
      listImages: Handlebars.compile([
        '{{#images}}',
          '<div id="{{id}}" class="item">',
            '<div class="header" style="height: {{../toolbarHeight}}px">',
              '<div id="{{id}}-osd-toolbar" class="toolbar">',
                '<a href="javascript:;" class="enable-zoom">Enable zoom</a>',
              '</div>',
            '</div>',
            '<div id="{{id}}-osd" class="image-instance">',
              '<img class="static-thumb">',
            '</div>',
            '<div class="title">{{title}}</div>',
          '</div>',
        '{{/images}}'
      ].join('')),

      // template for rendering tool bar with nav links
      navToolbar: Handlebars.compile([
        '<div class="{{navToolbarCls}}">',
          '<a href="javascript:;" class="mirador-btn mirador-icon-metadata-view"></a>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-thumbnails-view"></a>',
        '</div>'
      ].join(''))
    },


    /* Thumbnails view
    ---------------------------------------------------------------------------- */
    thumbnailsView: {
      // template for rendering images in thumbnails view
      listImages: Handlebars.compile([
        '<ul class="{{listingCssCls}} listing-thumbs">',
          '{{#thumbs}}',
            '<li>',
              '<a href="javascript:;">',
                '<img title="{{title}}" data-image-id="{{id}}" src="{{thumbUrl}}" height="{{../defaultHeight}}">',
                '<div class="thumb-label">{{title}}</div>',
              '</a>',
            '</li>',
          '{{/thumbs}}',
        '</ul>'
      ].join('')),

      // template for rendering tool bar with nav links
      navToolbar: Handlebars.compile([
        '<div class="{{navToolbarCls}}">',
          '<a href="javascript:;" class="mirador-btn mirador-icon-metadata-view"></a>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-scroll-view"></a>',
        '</div>'
      ].join(''))
    },


    /* Metadata view
    ---------------------------------------------------------------------------- */
    metadataView: {
      // template for rendering basic metadata terms
      listTerms: Handlebars.compile([
        '<div class="sub-title">Details (Metadata about physical object/intellectual work):</div>',
        '<dl class="{{metadataListingCls}}">',
          '{{#each details}}',
            '<dt>{{label}}:</dt><dd>{{value}}</dd>',
          '{{/each}}',
        '</dl>',
        '<div class="sub-title">Rights Metadata:</div>',
        '<dl class="{{metadataListingCls}}">',
          '{{#each rights}}',
            '<dt>{{label}}:</dt><dd>{{value}}</dd>',
          '{{/each}}',
        '</dl>',
        '<div class="sub-title">Linking Metadata:</div>',
        '<dl class="{{metadataListingCls}}">',
          '{{#each links}}',
            '<dt>{{label}}:</dt><dd>{{value}}</dd>',
          '{{/each}}',
        '</dl>',
        '<div class="sub-title">About (Metadata about this manuscript\'s manifest file):</div>',
        '<dl class="{{metadataListingCls}}">',
          '{{#each about}}',
            '<dt>{{label}}:</dt><dd>{{value}}</dd>',
          '{{/each}}',
        '</dl>'
      ].join(''), { noEscape: true }),

      // template for rendering tool bar with nav links
      navToolbar: Handlebars.compile([
        '<div class="{{navToolbarCls}}">',
          '<a href="javascript:;" class="mirador-btn mirador-icon-scroll-view"></a>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-thumbnails-view"></a>',
        '</div>'
      ].join(''))
    },

    /* Editor view
    -------------------------------------------------------------------------- */
    editorView: {
      // template for rendering basic metadata terms
      showTextArea: Handlebars.compile([
        '<div class="sub-title"><textarea id="{{editorID}}">wheeee</textarea></div>'
      ].join(''), { noEscape: true }),

      // template for rendering tool bar with nav links
      navToolbar: Handlebars.compile([
        '<div class="{{navToolbarCls}}">',
          '<a href="javascript:;" class="mirador-btn mirador-icon-scroll-view"></a>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-thumbnails-view"></a>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-load-editor"></a>',
        '</div>'
      ].join(''))
    },


    /* Open Layers Annotorius View
    ---------------------------------------------------------------------------- */
    openLayersAnnotoriusView: {
      // template for rendering open layers with annotorius
      content: Handlebars.compile([
        '<div class="ol-map-box" id="{{mapId}}" style="width:100%; height: 100%;"></div>'
      ].join('')),

      // template for rendering anno tool bar
      annoToolbar: Handlebars.compile([
        '<div class="{{annoToolbarCls}}">',
          '<a class="map-annotate-button mirador-btn mirador-icon-add-anno"></a>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-previous"></a>',
          '<a href="javascript:;" class="mirador-btn mirador-icon-next"></a>',
        '</div>'
      ].join(''))
    }

  };


  /* Helpers
  ---------------------------------------------------------------------------- */
  Handlebars.registerHelper('trimTitlePrefix', function(title) {
    title = title.replace(/^Beinecke MS \w+,? \[?/, '');
    title = title.replace(/\]$/, '');

    return title;
  });


}(Mirador));
