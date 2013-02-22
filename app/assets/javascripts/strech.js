function initStrech() {
	if($('.services').length === 0) return;
	var viewportHeight = $(window).height();
	var headerHeight = $("header.navBar").height();
	var heightContent = viewportHeight-headerHeight;
	if($(window).width() >= 1024) {
		$(".services a").removeAttr('style');
	}
	else if(heightContent>320){
		$(".services a").css({'height' : (heightContent/6), 'padding-top' : (heightContent/6)*2, 'background-position' : 'center '+((heightContent/6)-20)+"px"});
	}
}

$(document).ready(function() {
	initStrech();
	$(window).resize(function() {
		initStrech();
	});
});