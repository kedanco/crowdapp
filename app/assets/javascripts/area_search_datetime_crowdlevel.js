$(document).ready(function(){
	// $('.area-dropdown-list').hide();
	// $('.district-dropdown-list').hide();

	// $('.date-time').change(function(){
	// 	  $("#submit-area-district-search-datetime").click();		
	// })

	$("#datetimepicker1").on("dp.change", function(){
	 	  $("#submit-area-search-datetime-crowdlevel").click();
	});

	// $('.button_for_CrowdLevel').click(function(){
 //    	$(this).find('span').toggleClass('ion-ios-people ion-person');
 //    	$(this).val((function(button) {var alt = $(button).data('value'); 
 //    		$(button).data('value', $(button).val()); 
 //    		return alt;})(this))
	// });

	// $('.button_for_CrowdLevel').click(function(){
	// 	$("#submit-area-search-datetime-crowdlevel").click();
	// });

	$('#button_for_Crowded').click(function(){
		$('#button_for_Notcrowded').prop('checked', false);
		$('.crowded').toggleClass('btn-default btn-success');
		$('.notcrowded').removeClass('btn-success');
		$("#submit-area-search-datetime-crowdlevel").click();
	});

	$('#button_for_Notcrowded').click(function(){
		$('#button_for_Crowded').prop('checked', false);
		$('.notcrowded').toggleClass('btn-default btn-success');
		$('.crowded').removeClass('btn-success');
		$("#submit-area-search-datetime-crowdlevel").click();
	});

	// $('#AreaButton').on('click', function(){
	// 	$('.area-dropdown-list').show();

		// when click on one of the area-checkbox, pass params to output_to_map controller
		$(".area-checkbox").change(function() {
       
		  // $("#output_to_map_from_area #submit-area").click();
		  $("#submit-area-search-datetime-crowdlevel").click();
		});

	// });
})

