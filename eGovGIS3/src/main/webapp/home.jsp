<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/openlayers/openlayers.github.io@master/en/v6.12.0/css/ol.css">
<script src="https://cdn.jsdelivr.net/gh/openlayers/openlayers.github.io@master/en/v6.12.0/build/ol.js"></script>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>

<style>
#map {
	height: 780px;
	width: 100%;
}
.float{
border: 1px solid #2a5dc5;
	border-radius: 5px;
	background-color: #2a5dc5;
	font-size: 15px;
	color: white;
	text-align: center;
	position: absolute;
	top: 30px;
	left: -50px;
	
}
</style>
    
<title>오픈레이어스</title>
</head>
<body>
	<div id="map" class="map"></div>
	
	<div id="popup">
		<div id="popup-content"></div>
	</div>

	<script>
	var container = document.getElementById('popup');
	var content1 = document.getElementById('popup-content');
	var hover=null;
	var Feature = ol.Feature;
	var Map = ol.Map;
	var VectorLayer = ol.layer.Vector;
	var VectorSource = ol.source.Vector;
	var View = ol.View;
	var TileLayer = ol.layer.Tile;

	//var {Circle as CircleStyle, Fill, Stroke, Style} = ol.style;
	var CircleStyle= ol.style.Circle;
	var Stroke = ol.style.Stroke;
	var Style = ol.style.Style;
	var Fill = ol.style.Fill;

	var {LineString, Point} = ol.geom;
	var {getVectorContext} = ol.render;
	
	//피쳐 생성
	var point1 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([126.97, 37.56])),
		name: '시장1'
	});
	var point2 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([126.98, 37.562])),
		name: '시장2'
	});

	//피쳐 담아두는 소스 생성, 피쳐 담기
	const vectorSource = new VectorSource({
		features: [point1, point2]
	});

	//피쳐 소스 벡터 레이어 생성
	const vector = new VectorLayer({
	  source: vectorSource,
	  /* style: function (feature) {
	    return styles[feature.get('size')];   //이 코드 유용하다. 스타일을 동기적으로 할 수 있을수도 */
	  style: new Style({
		  
		  image: new CircleStyle({
		      radius: 5,
		      fill: new Fill({color: '#ff3700'}),
		      stroke: new Stroke({color: '#ff3700', width: 0.6})
		    })
		  })
	});

	//배경지도 레이어 생성
	const baseMap = new ol.layer.Tile({
		source: new ol.source.OSM({
		})
	});
	
	const mapOverlay = new ol.Overlay(({ element: container }));
		
	//지도 객체에 레이어 지정 
	const map = new ol.Map({
	  layers: [baseMap, vector],
	  overlays: [mapOverlay],
	  target: document.getElementById('map'), //지도를 표현할 div 요소를 지정 
	  view: new ol.View({
	    center: ol.proj.fromLonLat([126.9784147, 37.5666805]),  //초기 중심 좌표 
	    zoom: 12,
	    minZoom:7,
	    maxZoom:19
	    //projection:'EPSG:4326'
	  })
	});

	//마우스 커서 위치에 대한 지도 좌표를 받아, 가까운 피쳐를 찾아 피드백 시각화 하는 함수(displaySnap) 선언
	let point = null;
	let line = null;
	const displaySnap = function (coordinate) {
	  const closestFeature = vectorSource.getClosestFeatureToCoordinate(coordinate);
	  if (closestFeature === null) {
	    point = null;
	    line = null;
	  } else {
	    const geometry = closestFeature.getGeometry();
	    const closestPoint = geometry.getClosestPoint(coordinate);
	    if (point === null) {
	      point = new Point(closestPoint);
	    } else {
	      point.setCoordinates(closestPoint);
	    }
	    if (line === null) {
	      line = new LineString([coordinate, closestPoint]);
	    } else {
	      line.setCoordinates([coordinate, closestPoint]);
	    }
	  }
	  map.render();
	};

	//마우스 커서가 이동할 때 dispalySnap 함수 호출
	map.on('pointermove', function (evt) {
	  if (evt.dragging) {
	    return;
	  }
	  const coordinate = map.getEventCoordinate(evt.originalEvent);
	  displaySnap(coordinate);
	  
	  var cursorCoor = evt.coordinate;
	  //커서가 마커위에 있을 경우 포인터 아이콘으로 변경
	  map.getTargetElement().style.cursor = map.hasFeatureAtPixel(evt.pixel) ? 'pointer': '';
	  //커서에 마커가 없을 경우
	  if(hover!=null){
		  hover=null;
		}
	  //커서에 있는 마커 hover에 저장
	  map.forEachFeatureAtPixel(evt.pixel, function(f) {
			hover = f;
			return true;
		});
		//마커가 있을 경우
		if(hover){
			var content =
					"<div class='float'>"
                  	+ hover.get('name') //이름 값 뽑기
					+ "</div>";
			
			//popup-content 부분에 content를 넣어줌
			content1.innerHTML = content;
			
			//오버레이의 좌표를 정해줌
			mapOverlay.setPosition(cursorCoor);
		}else{
			content1.innerHTML = '';
		}

	});

	//마우스 커서를 클릭할 때 dispalySnap 함수 호출
	map.on('click', function (evt) {
	  displaySnap(evt.coordinate);
	});

	//라인 객체 스타일 
	const stroke = new Stroke({
	  color: 'rgba(151, 95, 255,0.7)',
	  width: 4,
	});
	const style = new Style({
	  stroke: stroke,
	  image: new CircleStyle({
	    radius: 10,
	    stroke: stroke,
	  }),
	});

	//포인트, 라인 그려주기 함수
	vector.on('postrender', function (evt) {
	  const vectorContext = getVectorContext(evt);
	  vectorContext.setStyle(style);
	  if (point !== null) {
	    vectorContext.drawGeometry(point);
	  }
	  if (line !== null) {
	    vectorContext.drawGeometry(line);
	  }
	});

	</script>


</body>

</html>

