(function ($) {
  Drupal.behaviors.ajSkin = {
    attach: function (context, settings) {
		if ($('#ajPageTableDefaults').length) {
			$('#ajPageTableDefaults').dataTable({
				"sScrollX": "100%"
			});
		} else if ($('#ajPageTableNoPagingOrSorting').length){
			$('#ajPageTableNoPagingOrSorting').dataTable({
				"bPaginate": false,
				"bSort": false,
				"bFilter": false
			});
		}
    }
  };
})(jQuery);