var curLatitude;
var curLongitude;

$(document).ready(function () {
	
    $(function() {        
        // Geolocation API에 액세스할 수 있는지를 확인
        if (navigator.geolocation) {
            //위치 정보를 얻기
            navigator.geolocation.getCurrentPosition (function(pos) {
                //$('#latitude').html(pos.coords.latitude);     // 위도
                //$('#longitude').html(pos.coords.longitude); // 경도
                curLatitude = pos.coords.latitude;
                curLongitude = pos.coords.longitude;
            });
        } else {
            alert("이 브라우저에서는 Geolocation이 지원되지 않습니다.")
        }
    });

	var trigger = $('.hamburger'),
		isClosed = false;

	trigger.click(function () {
		hamburger_cross();      
    });

	function hamburger_cross() {
		if (isClosed == false) {          
	        trigger.removeClass('is-open');
	        trigger.addClass('is-closed');
	        isClosed = true;
		} else {   
	        trigger.removeClass('is-closed');
	        trigger.addClass('is-open');
	        isClosed = false;
		}
	}
  
	$('[data-toggle="offcanvas"]').click(function () {
		$('#wrapper').toggleClass('toggled');
	});  
	
	$('.slider').slider({formatter: function(value) {return 'value: ' + value;}});
	
	$('.closeX').on('click', function(e){
		if($(e.target).hasClass('closeXp') == false){
			$(e.target.parentElement).hide();	
		}else{
			$(e.target.parentElement.parentElement).hide();
		}
		
		if(typeof pixel_layer!="undefined"){
			map.removeLayer(pixel_layer);
		}
	});
	
	$(".draggable").draggable({zIndex: 10, scroll: false});
	
	$('#pills-all-tab').on('click', function(e){
		$('#pills-all-table > tbody').empty();
		if(typeof spread_accident_layer!="undefined"){
			$('#pills-all-table > tbody:last').append('<tr><td style="width:10%"><img src="resources/images/rapid_place.png" style="width: 30px; height: 30px;"></td><td style="width:90%; padding-top: 5px"><span data-id="r1" style="display: block; padding-left: 10px; line-height: 30px;">(긴급대피 0.5km - 오산대피소) 청학동 가장로 733</span></td></tr>');
			$('#pills-all-table > tbody:last').append('<tr><td style="width:10%"><img src="resources/images/rapid_place.png" style="width: 30px; height: 30px;"></td><td style="width:90%; padding-top: 5px"><span data-id="r2" style="display: block; padding-left: 10px; line-height: 30px;">(긴급대피 1.2km - 오산병원) 궐동 611-4</span></td></tr>');
			$('#pills-all-table > tbody:last').append('<tr><td style="width:10%"><img src="resources/images/rapid_place.png" style="width: 30px; height: 30px;"></td><td style="width:90%; padding-top: 5px"><span data-id="r3" style="display: block; padding-left: 10px; line-height: 30px;">(긴급대피 2.0km - 세교병원) 수목원로 462</span></td></tr>');
			$('#pills-all-table > tbody:last').append('<tr><td style="width:10%"><img src="resources/images/safe_place.png" style="width: 30px; height: 30px;"></td><td style="width:90%; padding-top: 5px"><span data-id="n1" style="display: block; padding-left: 10px; line-height: 30px;">(안전지역 3.0km - 오산초등학교) 가수동 79-1</span></td></tr>');
			$('#pills-all-table > tbody:last').append('<tr><td style="width:10%"><img src="resources/images/safe_place.png" style="width: 30px; height: 30px;"></td><td style="width:90%; padding-top: 5px"><span data-id="n2" style="display: block; padding-left: 10px; line-height: 30px;">(안전지역 4.3km - 오산공원대피소) 외삼미동 628-7</span></td></tr>');
			
			shelter_mark('all');
			
			$('#pills-all tr').on('click', function(e){
				if($(e.target).is('span') == true){
					var view = ($(e.target).css('background-color') == 'rgba(0, 0, 0, 0)')?true:false;
					$('#pills-all span').css('background-color','');
					$('#pills-normal span').css('background-color','');
					$('#pills-rapid span').css('background-color','');
	
					if(view){
						$(e.target).css('background-color','#449d44');
						findroad($(e.target).data('id'), true);
					}else{
						$(e.target).css('background-color','');
						findroad($(e.target).data('id'), false);
					}
				}
			});
		}
	});
	
	$('#pills-normal-tab').on('click', function(e){
		$('#pills-normal-table > tbody').empty();
		if(typeof spread_accident_layer!="undefined"){
			$('#pills-normal-table > tbody:last').append('<tr><td style="width:10%"><img src="resources/images/safe_place.png" style="width: 30px; height: 30px;"></td><td style="width:90%; padding-top: 5px"><span data-id="n1" style="display: block; padding-left: 10px; line-height: 30px;">(안전지역 3.0km - 오산초등학교) 가수동 79-1</span></td></tr>');
			$('#pills-normal-table > tbody:last').append('<tr><td style="width:10%"><img src="resources/images/safe_place.png" style="width: 30px; height: 30px;"></td><td style="width:90%; padding-top: 5px"><span data-id="n2" style="display: block; padding-left: 10px; line-height: 30px;">(안전지역 4.3km - 오산공원대피소) 외삼미동 628-7</span></td></tr>');

			shelter_mark('normal');
			
			$('#pills-normal tr').on('click', function(e){
				if($(e.target).is('span') == true){
					var view = ($(e.target).css('background-color') == 'rgba(0, 0, 0, 0)')?true:false;
					$('#pills-all span').css('background-color','');
					$('#pills-normal span').css('background-color','');
					$('#pills-rapid span').css('background-color','');
					
					if(view){
						$(e.target).css('background-color','#449d44');
						findroad($(e.target).data('id'), true);
					}else{
						$(e.target).css('background-color','');
						findroad($(e.target).data('id'), false);
					}
				}
			});
		}
	});

	$('#pills-rapid-tab').on('click', function(e){
		$('#pills-rapid-table > tbody').empty();
		if(typeof spread_accident_layer!="undefined"){
			$('#pills-rapid-table > tbody:last').append('<tr><td style="width:10%"><img src="resources/images/rapid_place.png" style="width: 30px; height: 30px;"></td><td style="width:90%; padding-top: 5px"><span data-id="r1" style="display: block; padding-left: 10px; line-height: 30px;">(긴급대피 0.5km) [오산대피소] 청학동 가장로 733</span></td></tr>');
			$('#pills-rapid-table > tbody:last').append('<tr><td style="width:10%"><img src="resources/images/rapid_place.png" style="width: 30px; height: 30px;"></td><td style="width:90%; padding-top: 5px"><span data-id="r2" style="display: block; padding-left: 10px; line-height: 30px;">(긴급대피 1.2km) [오산병원] 궐동 611-4</span></td></tr>');
			$('#pills-rapid-table > tbody:last').append('<tr><td style="width:10%"><img src="resources/images/rapid_place.png" style="width: 30px; height: 30px;"></td><td style="width:90%; padding-top: 5px"><span data-id="r3" style="display: block; padding-left: 10px; line-height: 30px;">(긴급대피 2.0km) [세교병원] 수목원로 462</span></td></tr>');

			shelter_mark('rapid');
			
			$('#pills-rapid tr').on('click', function(e){
				if($(e.target).is('span') == true){
					var view = ($(e.target).css('background-color') == 'rgba(0, 0, 0, 0)')?true:false;
					$('#pills-all span').css('background-color','');
					$('#pills-normal span').css('background-color','');
					$('#pills-rapid span').css('background-color','');
					
					if(view){
						$(e.target).css('background-color','#449d44');
						findroad($(e.target).data('id'), true);
					}else{
						$(e.target).css('background-color','');
						findroad($(e.target).data('id'), false);
					}
				}
			});
		}
	});
	
	
});

