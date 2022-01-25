$(function(){

	$('#accident_al_sp').on('click', function(e){
		$('#msg-dim-layer .pop-layer').css('background-color','#ff0639');
		$('#msg-dim-layer .ctxt').text('등록된 관계자에게 사고발생 정보를').append('<br>').append('공유합니다.')
		$('#msg-dim-layer').fadeOut('fast').fadeIn('fast');
	});
	
	$('#accident_fin').on('click', function(e){
		$('#msg-dim-layer .pop-layer').css('background-color','#83af25');		
		$('#msg-dim-layer .ctxt').text('수습 완료 상황 정보가 등록됩니다.').append('<br>').append('사고처리 담당자 확인 후').append('<br>').append('대응상황이 해제됩니다.')
		$('#msg-dim-layer').fadeOut('fast').fadeIn('fast');
	});
	
	$('#res2accident').on('click',function(){

		var pixel_box3_onoffchk = $('#pixel_box3').css("display");
		var pixel_box3_src = $('#pixel_box3_img').attr("src");
		
		if(pixel_box3_onoffchk == "block"){
			if(pixel_box3_src != "resources/images/res2accident.PNG"){
				$('#pixel_box3_img').attr("src", "resources/images/res2accident.PNG");
			}else{
				$('#pixel_box3').hide();
			}
		}else{
			$('#pixel_box3_img').attr("src", "resources/images/res2accident.PNG");
			$('#pixel_box3').show();
		}
	});

	$('#resSystem').on('click',function(){

		var pixel_box3_onoffchk = $('#pixel_box3').css("display");
		var pixel_box3_src = $('#pixel_box3_img').attr("src");
		
		if(pixel_box3_onoffchk == "block"){
			if(pixel_box3_src != "resources/images/resSystem.PNG"){
				$('#pixel_box3_img').attr("src", "resources/images/resSystem.PNG");
			}else{
				$('#pixel_box3').hide();
			}
		}else{
			$('#pixel_box3_img').attr("src", "resources/images/resSystem.PNG");
			$('#pixel_box3').show();
		}
	});
	
});