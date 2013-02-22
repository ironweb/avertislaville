function initHomeMap (coords){
	$("h1.logozone").after("<div id='zoneHomeMap'><div id='homeMap'></div><div id='mask'></div></div>");
	var imgmarker='../img/marker.png';
	var objectMarker = coords.map(function(coord) {
		return { latitude: coord.lat, longitude: coord.lon, icon: imgmarker};
	});
	$("#homeMap").goMap({
        navigationControl: false,
        mapTypeControl: false,
        scrollwheel: false,
        disableDoubleClickZoom: true,
        zoom: 12,
        maptype: 'ROADMAP',
        markers: objectMarker
    });
	$.goMap.setMap({latitude:'46.836944988044465', longitude:'-71.28376007080078'});
}

$(document).on('homemap:ready', function(e, coords) {
	// Idempotence
	if($("#zoneHomeMap").length !== 0) return;
	$(window).on('resize.homemap', function() {
		if($("#zoneHomeMap").length == 0 && $(window).width() > 960) {
			initHomeMap(coords);
		}
	})
	$(window).trigger('resize.homemap');
	$(document).on('page:change', function() { $(window).off('.homemap'); });
});
