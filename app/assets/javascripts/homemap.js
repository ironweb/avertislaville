function initHomeMap (){
	$("h1.logo").after("<div id='zoneHomeMap'><div id='homeMap'></div><div id='mask'></div></div>");
	var imgmarker='../img/marker.png';
	var objectMarker = eventsCoords.map(function(coord) {
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

$(document).ready(function() {
	if($(".controller-home").length === 0) return;
	if($(window).width()>=1024){
		initHomeMap();
	}
});