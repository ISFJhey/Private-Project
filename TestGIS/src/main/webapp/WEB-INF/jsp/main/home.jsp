<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setContentType("text/html;charset=UTF-8"); %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=10">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Web GIS 테스트 - 유해물질 재난안전</title>

<c:import url="../include/css_define.jsp"></c:import>
<c:import url="../include/js_define.jsp"></c:import>

</head>
<body>
	<!-- header -->
	<nav class="navbar-static-top">
		<div class="container-fluid">
			<div class="navbar-header">
				<a class="navbar-brand" href="#">유해물질 재난안전 정보 확인 서비스</a>
			</div>
		</div>
	</nav>
	
	<!-- contents -->
	<div id="page-content-wrapper">
		<div id="alarm-dim-layer" class="dim-layer">
		    <div class="dimBg"></div>
		    <div id="layer2" class="pop-layer">
		        <div class="pop-container">
		            <div class="pop-conts">
		                <p class="ctxt mb20">유해물질 유출 대피 알림<br>염화티오닐(Thionyl chloride)</p>
		            </div>
		        </div>
		    </div>
		</div>

		<div id="msg-dim-layer" class="dim-layer">
		    <div class="dimBg"></div>
		    <div id="layer2" class="pop-layer">
		    	<div class="closeX closeXp">x</div>
		        <div class="pop-container">
		            <div class="pop-conts">
		                <p class="ctxt mb20"></p>
		            </div>
		        </div>
		    </div>
		</div>
		
		<div id="map">
			<canvas id="windyMap" class="fill"></canvas>
			
			<div id="pixel_box">
				<div class="closeX">x</div>
				<div id="overlay-ses"></div>
			</div>

			<div id="pixel_box1">
				<div class="panel-heading">
					<h4 style="font-size: 18px; margin-top: 5px">사고정보</h4>
				</div>
				<div id="overlay-ses2" class="overlay-ses2">
					<div class="category">
						<div class="item cf" style="margin-top: 10px;">
							<div class="item-title fl w-30"><h4>발생시각 : </h4></div>
							<div class="item-number fl w-60" id="currentTime"><h4></h4></div>
						</div>
						<div class="item cf">
							<div class="item-title fl w-30"><h4>사고진행 : </h4></div>
							<div class="item-number fl w-60" id="runningTime"><h4></h4></div>
						</div>
						<div class="item cf" style="margin-bottom: 10px;">
							<button id="res2accident" type="button" class="btn btn-danger" style="width: 45%; height: 30px;">대응요령</button>
							<button id="resSystem" type="button" class="btn btn-success" style="width: 45%; height: 30px; margin-left: 5px;margin-right:10px">대응체계</button>
						</div>
						
					</div>
				</div>
			</div>

			<div id="pixel_box4">
				<div class="panel-heading">
					<h4 style="font-size: 18px; margin-top: 5px">지도 on/off</h4>
				</div>
				<div id="overlay-ses2" class="overlay-ses2" style="padding-top: 5px;">
					<div class="category">
						<div class="item cf" style="margin-bottom: 10px;">
							<button id="map_onoff_spread" type="button" class="btn btn-success" style="width: 45%; height: 40px;">확산 Map on</button>
							<button id="map_onoff_wind" type="button" class="btn btn-success" style="width: 45%; height: 40px; margin-left: 5px;margin-right:10px">바람 Map on</button>
						</div>
						
					</div>
				</div>
			</div>

			
			<div id="pixel_box2">
				<div class="panel-heading">
					<h4 style="font-size: 18px; margin-top: 5px">대응상황</h4>
				</div>
				<div id="overlay-ses2" class="overlay-ses3">
					<div class="category">
						<div class="item cf" style="margin-top: 10px; background-color: #d9534f">
							<div class="item-title fl w-30" style="padding-left: 5px"><h4>1단계</h4></div>
							<div class="item-number fl w-60"><h4>화학사고 발생,<br>사고접수 및 전파</h4></div>
						</div>
						<div class="item cf" style="text-align-last: center;">
							<img src="resources/images/arrow_down.png" style="padding: 10px 0px; width: 20%;">
						</div>

						<div class="item cf" style="background-color: #6d6767">
							<div class="item-title fl w-30" style="padding-left: 5px"><h4>2단계</h4></div>
							<div class="item-number fl w-60"><h4>위기대응반 가동</h4></div>
						</div>
						<div class="item cf" style="text-align-last: center;">
							<img src="resources/images/arrow_down.png" style="padding: 10px 0px; width: 20%;">
						</div>
						
						<div class="item cf" style="background-color: #6d6767">
							<div class="item-title fl w-30" style="padding-left: 5px"><h4>3단계</h4></div>
							<div class="item-number fl w-60"><h4>화학사고 수습본부<br>설치 및 사고수습</h4></div>
						</div>
						<div class="item cf" style="text-align-last: center;">
							<img src="resources/images/arrow_down.png" style="padding: 10px 0px; width: 20%;">
						</div>
						
						<div class="item cf" style="background-color: #6d6767">
							<div class="item-title fl w-30" style="padding-left: 5px"><h4>4단계</h4></div>
							<div class="item-number fl w-60"><h4>사고지역 복구 및<br>사고 후 영향조사,<br>종료</h4></div>
						</div>
					</div>
				</div>
			</div>


			
			<div id="pixel_box3">
				<div class="closeX">x</div>
				<div id="overlay-ses2" style="padding-left: 10px;">
					<div class="category">
						<div class="item cf" style="margin-top: 10px;">
							<img id="pixel_box3_img" src="resources/images/res2accident.PNG" style="width: 700px; padding-right: 10px; padding-bottom: 10px;">
						</div>

					</div>
				</div>
			</div>


		</div>
	</div>
	
	<div id="wrapper" class="toggled">
		<!-- sidemenu -->
		<nav id="sidebar-wrapper">
			<div class="accordion-group panel">
				<div class="panel-heading" data-parent="#sidebar-wrapper" href="#collapse1">
					<h4 class="panel-title"><a href="#">대피소 안내</a></h4>
				</div>
				<div id="collapse1" class="collapse in">
					<div class="panel-body">
						<div>
							<table>
								<tr>
									<td style="padding: 0px 0px 5px 0px">
										<img src="resources/images/current_location.png" style="width: 30px; height: 30px;"> 현 위치 :
									</td>
									<td style="padding: 0px 0px 5px 5px">
										<span id="address"></span>
									</td>
								</tr>
							</table>
						</div>
						<div style="width: 100%; border-bottom: 1px solid white;"></div>
						<div style="padding-top: 5px">
							<ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
								<li class="nav-item" style="width: 31%; text-align: center;">
							    	<a class="nav-link active" id="pills-all-tab" data-toggle="pill" href="#pills-all" role="tab" aria-controls="pills-all" aria-selected="true">전체</a>
								</li>
							  	<li class="nav-item" style="width: 31%; text-align: center;">
							    	<a class="nav-link" id="pills-normal-tab" data-toggle="pill" href="#pills-normal" role="tab" aria-controls="pills-normal" aria-selected="false">안전지역</a>
							  	</li>
							  	<li class="nav-item" style="width: 31%; text-align: center;">
								    <a class="nav-link" id="pills-rapid-tab" data-toggle="pill" href="#pills-rapid" role="tab" aria-controls="pills-rapid" aria-selected="false">긴급대피</a>
							  	</li>
							</ul>
							<div style="width: 100%; border-bottom: 1px solid white;"></div>
							<div class="tab-content" id="pills-tabContent" style="height: 200px;">
					  			<div class="tab-pane fade active" id="pills-all" role="tabpanel" aria-labelledby="pills-all-tab">
					  				<table id="pills-all-table" style="width:100%">
										<tbody>
										</tbody>
					  				</table>
					  			</div>
					  			<div class="tab-pane fade" id="pills-normal" role="tabpanel" aria-labelledby="pills-normal-tab">
					  				<table id="pills-normal-table" style="width:100%">
										<tbody>
										</tbody>
					  				</table>
					  			</div>
					  			<div class="tab-pane fade" id="pills-rapid" role="tabpanel" aria-labelledby="pills-rapid-tab">
					  				<table id="pills-rapid-table" style="width:100%">
										<tbody>
										</tbody>
					  				</table>
					  			</div>
							</div>
						</div>
						
						
					</div>
				</div>
			</div>
			
			<div class="accordion-group panel">
				<div class="panel-heading" data-parent="#sidebar-wrapper" href="#collapse2">
					<h4 class="panel-title"><a href="#">사고 상세 정보</a></h4>
				</div>
				<div id="collapse2" class="collapse in">
					<div class="panel-body">
						<div>
							<table style="width:100%">
								<tr>
									<td style="width:30%; padding-bottom:10px">사고위치 :</td>
									<td id="accident" style="width:70%; padding-bottom: 10px;"></td>
								</tr>
								
								<tr>
									<td style="width:30%; padding-bottom:10px">사고물질 :</td>
									<td id="accidentMatrial" style="width:70%; padding-bottom: 10px;"></td>
								</tr>


								<tr style="border-bottom: 1px solid white;"><td colspan="2"></tr>

								<tr>
									<td rowspan="3" style="width:30%; padding-bottom:10px">확산예상범위 :<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(위험도)</td>
									<td style="width:70%;">
										<span id="accident_area1" style="background-color: #d9534f;display: block; padding-left: 10px; line-height: 30px;"></span>
									</td>
								</tr>
								<tr>
									<td style="width:70%;">
										<span id="accident_area2" style="background-color: #ded30a;display: block; padding-left: 10px; line-height: 30px;"></span>
									</td>
								</tr>
								<tr>
									<td style="width:70%;">
										<span id="accident_area3" style="background-color: #5cb85c;display: block; padding-left: 10px; line-height: 30px;"></span>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="width: 100%; border-bottom: 1px solid white; padding-top: 10px;"></div>
						
						<div style="padding-top: 40px;">
							<button type="button" id="accident_al_sp" class="btn btn-danger" style="width: 48%; height: 50px;">사고발생 공유</button>
							<button type="button" id="accident_fin" class="btn btn-success" style="width: 48%; height: 50px; margin-left: 5px;">사고수습 처리 완료</button>
						</div>
						
						<div style="padding-top: 40px;">
							<table style="width:100%">
								<tr>
									<td style="width: 60%; padding-left: 50px;">
										<img src="resources/images/sun.svg">
									</td>
									<td style="width: 40%; font-size: 20px; padding-left: 10px;">
										17℃ 남동<br>1.9 m/s
									</td>
								</tr>
							</table>
						</div>

						<div style="padding-top: 20px;padding-left: 20px;">
							<table style="width:100%">
								<tr>
									<td style="width: 20%;">강수확률 :</td>
									<td style="width: 30%;">10%</td>
									<td style="width: 20%;">강수량 :</td>
									<td style="width: 30%;">-</td>
								</tr>
								<tr>
									<td style="width: 20%;">최저/최고 : </td>
									<td style="width: 30%;">11.2 / 21.3</td>
									<td style="width: 20%;">습도 :</td>
									<td style="width: 30%;">40.3%</td>
								</tr>
							</table>
						</div>

						<div style="padding-top: 20px;">
							<table style="width:100%">
								<tr>
									<td rowspan="2" style="width: 40%; padding-left: 20px;">미세먼지 PM10 :</td>
									<td rowspan="2" style="width: 20%; padding-left: 20px;">
										<img src="resources/images/item01.png" style="width: 20px;">
									</td>
									<td style="width: 40%; padding-left: 10px;">36(1H)
									</td>									
								</tr>
								<tr>
									<td style="width: 40%; padding-left: 10px;">89(24H)
									</td>
								</tr>
							</table>
						</div>


					</div>
				</div>
			</div>

	
		</nav>
		
		<!-- map_menu -->
<!-- 		<div class="mapcontrol">기본지도기능</div> -->
		
		<button type="button" class="hamburger is-open" data-toggle="offcanvas"></button>
		
	</div>

</body>
</html>
