(function ($) {
  Drupal.behaviors.ajSkin = {
    attach: function (context, settings) {
		$('#ajPageTable').dataTable();
    }
  };
})(jQuery);