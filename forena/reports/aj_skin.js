(function ($) {
  Drupal.behaviors.ajSkin = {
    attach: function (context, settings) {
		if ($('#ajPageTable').length) {
			$('#ajPageTable').dataTable();
		} else if ($('#ajPageTableNoPagingOrSorting').length){
			$('#ajPageTable').dataTable({
				"paging": false,
				"ordering": false
			});
		}
    }
  };
})(jQuery);