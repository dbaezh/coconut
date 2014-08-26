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
		} else if ($('#ajOverdue').length){
			$('#ajOverdue').dataTable({
				"bPaginate": false,
				"bSort": true,
				"bFilter": false
			});
		} else if ($('#ajRiskScreen').length){
			$('#ajRiskScreen').dataTable({
				"bPaginate": false,	
				"bFilter": false,
				"bSort": true
			    
			});
		
			$('#ajRiskScreenTotal').dataTable({
				"bPaginate": false,	
				"bFilter": false,
				"bSort": false
			    
			});
		}else if ($('#ajActiveParticipants').length){
			$('#ajActiveParticipants').dataTable({
				"bPaginate": true,
				"bSort": true,
				"bFilter": false
			});
		}else if ($('#ajActiveParticipants2').length){
			$('#ajActiveParticipants2').dataTable({
				"bPaginate": true,
				"bSort": true,
				"bFilter": false
			});
		}
    }
  };
})(jQuery);


