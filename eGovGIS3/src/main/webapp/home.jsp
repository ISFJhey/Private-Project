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
</style>
    
<title>오픈레이어스</title>
</head>
<body>
	<div id="map" ></div>

	<script>
	var Feature = ol.Feature;
	var Map = ol.Map;
	var VectorLayer = ol.layer.Vector;
	var VectorSource = ol.source.Vector;
	var View = ol.View;

	//var {Circle as CircleStyle, Fill, Stroke, Style} = ol.style;
	var CircleStyle= ol.style.Circle;
	var Stroke = ol.style.Stroke;
	var Style = ol.style.Style;
	var Fill = ol.style.Fill;

	var {LineString, Point} = ol.geom;
	var {getVectorContext} = ol.render;

	/* const count = 20;
	const features = new Array(count);
	const e = 18000000;
	for (let i = 0; i < features.length; ++i) {
	  features[i] = new Feature({
	    'geometry': new Point([
	      2 * e * Math.random() - e,
	      2 * e * Math.random() - e,
	    ]),
	    'i': i,
	    'size': i % 2 ? 10 : 20,
	  });
	} */
	
	/* function storeCoodinate(xVal, yVal, array) {
		array.push({x: xVal, y: yVal});
	}
	var features = [];
	storeCoodinate(37, 126.9784147, features);
	storeCoodinate(37.5665347, 126.9784633, features);
	for(var i = 0; i < features.length; i++) {
		features[i] = new Feature({
			'geometry': new Point([
				features[i].x,
				features[i].y
			]),
			'i': i,
			'size': 10
		})	
	} */
	
	var features = new Feature(new Point([126.9784633, 37.5665347]));
	var features1 = new Feature(new Point([37.561434, 126.9782344]));
	
	//포인트 스타일
	const styles = {
	  '10': new Style({
	    image: new CircleStyle({
	      radius: 5,
	      fill: new Fill({color: '#f7feb9'}),
	      stroke: new Stroke({color: '#97ffa1', width: 0.6}),
	    }),
	  }),
	  '20': new Style({
	    image: new CircleStyle({
	      radius: 10,
	      fill: new Fill({color: '#666666'}),
	      stroke: new Stroke({color: '#bada55', width: 1}),
	    }),
	  }),
	};

	const vectorSource = new VectorSource({
	  features: [features, features1]
	});

	//포인트 피쳐 벡터 레이어 생성
	const vector = new VectorLayer({
	  source: vectorSource,
	  /* style: function (feature) {
	    return styles[feature.get('size')];   //이 코드 유용하다. 스타일을 동기적으로 할 수 있을수도 */
	  style: new Style({
		  
		  image: new CircleStyle({
		      radius: 5,
		      fill: new Fill({color: '#f7feb9'}),
		      stroke: new Stroke({color: '#97ffa1', width: 0.6})
		    })
		  })
	});

	//배경지도 레이어 생성
	const baseMap = new ol.layer.Tile({
		source: new ol.source.XYZ({
			url: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
			projectrion: 'EPSG:3857',
		})
	});
		
	//지도 객체에 레이어 지정 
	const map = new ol.Map({
	  layers: [baseMap, vector],
	  target: document.getElementById('map'), //지도를 표현할 div 요소를 지정 
	  view: new ol.View({
	    center: ol.proj.fromLonLat([126.9784147, 37.5666805]),  //초기 중심 좌표 
	    zoom: 0,
	    /* minZoom:7,
	    maxZoom:19 */
	    projection:'EPSG:3857'
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
	});

	//마우스 커서를 클릭할 때 dispalySnap 함수 호출
	map.on('click', function (evt) {
	  displaySnap(evt.coordinate);
	});

	//포인트, 라인 객체 스타일 
	const stroke = new Stroke({
	  color: 'rgba(255,255,0,0.5)',
	  width: 3,
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

