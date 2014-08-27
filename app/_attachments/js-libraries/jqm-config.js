$(document).bind("mobileinit", function () {
    $.mobile.ajaxEnabled = false;
    $.mobile.linkBindingEnabled = false;
    $.mobile.hashListeningEnabled = false;
    $.mobile.pushStateEnabled = false;

    // Remove page from DOM when it's being replaced
    // VBJQUERY replaced live with on when moving to jQUery 1.9
    /*$('div[data-role="page"]').live('pagehide', function (event, ui) {
        $(event.currentTarget).remove();
    });*/
    $('div[data-role="page"]').on('pagehide', function (event, ui) {
        $(event.currentTarget).remove();
    });
});