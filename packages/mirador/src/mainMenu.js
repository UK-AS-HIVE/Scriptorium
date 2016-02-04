Template.mirador_mainMenu.onRendered(function() {
  console.log('mainMenu.onRendered');
  var j = $('<div/>');
  var k = Blaze.render(Template.mirador_mainMenu_loadWindowContent, j.get(0));
  // menu 'Load Window'
  this.$('.load-window').tooltipster({
    arrow: true,
    content: j,
    contentCloning: false,
    interactive: true,
    position: 'bottom',
    theme: '.tooltipster-mirador',

    functionReady: function(origin, continueTooltip) {
      /*var heightTooltipster = jQuery('.mirador-viewer').height() * 0.8;

      jQuery('.mirador-listing-collections').height(heightTooltipster);
      jQuery('.mirador-listing-collections ul').height(heightTooltipster - 70);*/
    }/*,
    functionBefore: function(origin, continueTooltip) {
      j = $('<div/>');
      k = Blaze.render(Template.mirador_mainMenu_loadWindowContent, j.get(0));
      continueTooltip();
      origin.tooltipster('content', j);
    },
    functionAfter: function(origin) {
      j.remove();
    }*/
  });
});

Template.mirador_mainMenu_loadWindowContent.helpers({
  'collections': function() {
    return AvailableManifests.find();
  },
  'imageData': function() {
    if (this.manifestPayload.sequences.length == 0)
      return [];
    return this.manifestPayload.sequences[0].canvases;
  }
});

Template.mirador_mainMenu_loadWindowContent.events({
  'change .mirador-listing-collections select': function(e, tpl) {
    var manifestId = tpl.$('option:selected').data('manifest-id');

    tpl.$('.mirador-listing-collections ul').hide();
    tpl.$('.mirador-listing-collections ul.ul-'+manifestId).show();
  },
  'click .mirador-listing-collections ul': function(e, tpl) {
  }
});

(function($) {

  $.MainMenu = function(options) {

    jQuery.extend(true, this, {
      element:                    null,
      mainMenuHeight:             $.DEFAULT_SETTINGS.mainMenu.height,
      mainMenuWidth:              $.DEFAULT_SETTINGS.mainMenu.width,
      windowOptionsMenu:          null,
      loadWindow:                 null,
      clearLocalStorage:          '',
      viewerCls:                  'mirador-viewer',
      mainMenuBarCls:             'mirador-main-menu-bar',
      mainMenuCls:                'mirador-main-menu',
      windowOptionsMenuCls:       'mirador-window-options-menu',
      clearLocalStorageCls:       'clear-local-storage',
      clearLocalStorageDialogCls: 'mirador-main-menu-clear-local-storage',
      collectionsListingCls:      'mirador-listing-collections'
    }, options);

    this.element  = this.element || jQuery('<div/>');

    this.render();
    this.attachMainMenuEvents();
  };


  $.MainMenu.prototype = {

    render: function() {
      this.element
        .addClass(this.mainMenuBarCls)
        .height(this.mainMenuHeight)
        .width(this.mainMenuWidth)
        .appendTo(this.appendTo);

      this.element.append($.Templates.mainMenu.menuItems({
        mainMenuCls: this.mainMenuCls
      }));

      this.windowOptionsMenu = new $.MainMenuWindowOptions({
        windowOptionsMenuCls: this.windowOptionsMenuCls
      });

      $.loadWindowContent = "Loading...";

      this.loadWindow = new $.MainMenuLoadWindow({
        collectionsListingCls:  this.collectionsListingCls
      });

      this.clearLocalStorage = $.Templates.mainMenu.clearLocalStorage({
        cssCls: this.clearLocalStorageDialogCls,
        selectorClearLocalStorage: '.' + this.mainMenuCls + ' .' + this.clearLocalStorageCls
      });


    },


    attachMainMenuEvents: function() {
      var elMainMenu = this.element.find('.' + this.mainMenuCls);
          selectorBookmarkWorkspace = '.bookmark-workspace',
          selectorLoadWindow        = '.load-window',
          selectorWindowOptions     = '.window-options',
          selectorClearLocalStorage = '.' + this.clearLocalStorageCls,
          selectorWindowOptionsMenu = '.' + this.mainMenuBarCls + ' .' + this.windowOptionsMenuCls,
          _this = this;

      // menu 'Bookmark Workspace'
      elMainMenu.on('click', selectorBookmarkWorkspace, function() {
      });

      // menu 'Load Window'
      elMainMenu.find(selectorLoadWindow).tooltipster({
        arrow: true,
        content: _this.loadWindow.element,
        interactive: true,
        position: 'bottom',
        theme: '.tooltipster-mirador',

        functionReady: function(origin, continueTooltip) {
          var heightTooltipster = jQuery('.' + _this.viewerCls).height() * 0.8;

          jQuery('.' + _this.collectionsListingCls).height(heightTooltipster);
          jQuery('.' + _this.collectionsListingCls + ' ul').height(heightTooltipster - 70);
        }

      });

      // Window Options
      elMainMenu.find(selectorWindowOptions).tooltipster({
        arrow: true,
        content: _this.windowOptionsMenu.html,
        interactive: true,
        theme: '.tooltipster-mirador'
      });

      // menu 'Clear Local Storage'
      elMainMenu.find(selectorClearLocalStorage).tooltipster({
        arrow: true,
        content: _this.clearLocalStorage,
        interactive: true,
        theme: '.tooltipster-mirador'
      });

    }

  };

}(Mirador));