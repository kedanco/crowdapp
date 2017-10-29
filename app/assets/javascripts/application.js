// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//


//= require jquery
//= require bootstrap-sprockets
//= require rails-ujs
//= require turbolinks
//= require jquery
//= require bootstrap-sprockets
//= require_tree .
//= require moment
//= require bootstrap-datetimepicker




// Add Google Maps
function initMap() {
  var customMapType = new google.maps.StyledMapType([{
    "featureType": "all",
    "elementType": "labels.text",
    "stylers": [{
      "color": "#6c6753"
    }]
  }, {
    "featureType": "all",
    "elementType": "labels.text.stroke",
    "stylers": [{
      "color": "#ffffff"
    }]
  }, {
    "featureType": "administrative",
    "elementType": "labels.text.fill",
    "stylers": [{
      "color": "#444444"
    }]
  }, {
    "featureType": "landscape",
    "elementType": "geometry.fill",
    "stylers": [{
      "color": "#ffffff"
    }, {
      "lightness": "0"
    }, {
      "gamma": "1.00"
    }]
  }, {
    "featureType": "poi",
    "elementType": "all",
    "stylers": [{
      "visibility": "off"
    }]
  }, {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [{
      "color": "#51e6a6"
    }]
  }, {
    "featureType": "road",
    "elementType": "labels.text",
    "stylers": [{
      "color": "#6c6753"
    }, {
      "visibility": "simplified"
    }]
  }, {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [{
      "saturation": "-100"
    }, {
      "lightness": "11"
    }]
  }, {
    "featureType": "transit",
    "elementType": "all",
    "stylers": [{
      "visibility": "off"
    }]
  }, {
    "featureType": "water",
    "elementType": "all",
    "stylers": [{
      "visibility": "on"
    }]
  }, {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [{
      "color": "#51ffa6"
    }, {
      "lightness": "27"
    }, {
      "saturation": "-14"
    }]
  }], {
    name: 'Styled'
  });
  var customMapTypeId = 'custom_style';

  var latLng = {
    lat: 39.2257618,
    lng: 9.122245
  };

  var map = new google.maps.Map(document.getElementById("map"), {
    zoom: 13,
    center: latLng,
    mapTypeControlOptions: {
      mapTypeIds: [google.maps.MapTypeId.ROADMAP, customMapTypeId]
    }
  });

  var marker = new google.maps.Marker({
    position: latLng,
    map: map,
    title: "I'm here!"
  });

  map.mapTypes.set(customMapTypeId, customMapType);
  map.setMapTypeId(customMapTypeId);

}
