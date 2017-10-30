$(document).ready(function(){
	$('.area-dropdown-list').hide();
	$('.district-dropdown-list').hide();

	// $('.date-time').change(function(){
	// 	  $("#submit-area-district-search-datetime").click();		
	// })

	$("#datetimepicker1").on("dp.change", function(){
	 	  $("#submit-area-district-search-datetime").click();
	});


	$('#AreaButton').on('click', function(){
		$('.area-dropdown-list').show();

		// when click on one of the area-checkbox, pass params to output_to_map controller
		$(".area-checkbox").change(function() {
       
		  // $("#output_to_map_from_area #submit-area").click();
		  $("#submit-area-district-search-datetime").click();
		});

	});

	$('#DistrictButton').on('click', function(){
		$('.district-dropdown-list').show();

		// when click on one of the district-checkbox, pass params to output_to_map controller
		$(".district-checkbox").change(function() {
		  $("#submit-area-district-search-datetime").click();
		});	

	});
})

