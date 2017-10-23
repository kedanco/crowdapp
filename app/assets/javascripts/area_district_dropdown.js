$(document).ready(function(){
	$('.area-dropdown-list').hide();
	$('.district-dropdown-list').hide();

	$('#AreaButton').on('click', function(){
		$('.area-dropdown-list').show();				
	});

	$('#DistrictButton').on('click', function(){
		$('.district-dropdown-list').show();				
	});
})



