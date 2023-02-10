$.fn.bindFirst = function(name, fn) {
    // bind as you normally would
    // don't want to miss out on any jQuery magic
    this.on(name, fn);

    // Thanks to a comment by @Martin, adding support for
    // namespaced events too.
    this.each(function() {
        var handlers = $._data(this, 'events')[name.split('.')[0]];
        // take out the handler we just inserted from the end
        var handler = handlers.pop();
        // move it at the beginning
        handlers.splice(0, 0, handler);
    });
};

$.fn.resizePopup = function(_contentHeight, _contentWidth)
{
    var popupProper = this.findPopupDialog();
    var popupContent = this.findPopupDialogContentContainer();

    _contentHeight = _contentHeight || popupContent.height();
    _contentWidth = _contentWidth || popupContent.width();

    var popupProperHeight = popupProper.height();
    var popupContentHeight = popupContent.height();
    var headerHeight = this.find(".header").height();
    var footerHeight = this.find(".footer").height();
    var subHeaderHeight = this.find(".sub-header").height();
    var baseHeight = 8 + headerHeight + subHeaderHeight + footerHeight;
    var totalWidth = Math.max(popupProper.width(), _contentWidth);
    var totalHeight = baseHeight + _contentHeight;

    popupProper.css("height",  totalHeight);
    popupProper.css("width", totalWidth);
    popupProper.css("background-size", totalWidth + " " + totalHeight)
    popupContent.css("height", _contentHeight)
    popupContent.css("width", _contentWidth)
    popupProper.centerPopupDialogWithinParent()
};

// triggers remove events for elements when they get removed in any way https://stackoverflow.com/a/18410186
MSU.$_cleanData = $.cleanData;
$.cleanData = function( elems ) {
    for ( var i = 0, elem; (elem = elems[i]) != null; i++ ) {
        try {
            $( elem ).triggerHandler( "remove" );
        // http://bugs.jquery.com/ticket/8235
        } catch( e ) {}
    }
    MSU.$_cleanData( elems );
};
