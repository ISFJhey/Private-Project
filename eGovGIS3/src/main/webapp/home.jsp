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
	height:100%;
	width: 100%;
}
html, body{
	height:100%;
}

.float {
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

.ol-tooltip {
	position: relative;
	background: rgba(0, 0, 0, 0.5);
	border-radius: 4px;
	color: white;
	padding: 4px 8px;
	opacity: 0.7;
	white-space: nowrap;
	font-size: 12px;
	cursor: default;
	user-select: none;
}

.ol-tooltip-measure {
	opacity: 1;
	font-weight: bold;
}

.ol-tooltip-static {
	background-color: #ffcc33;
	color: black;
	border: 1px solid white;
}

.ol-tooltip-measure:before, .ol-tooltip-static:before {
	border-top: 6px solid rgba(0, 0, 0, 0.5);
	border-right: 6px solid transparent;
	border-left: 6px solid transparent;
	content: "";
	position: absolute;
	bottom: -6px;
	margin-left: -7px;
	left: 50%;
}

.ol-tooltip-static:before {
	border-top-color: #ffcc33;
}
</style>
    
<title>오픈레이어스</title>
</head>
<body>
	<h4>가까운 시설 찾기</h4>
	
	<div id="map" class="map">
	</div>
	
	<div id="popup">
		<div id="popup-content"></div>
	</div>
	
	<form>
		<label>타입선택지 추후 추가 예정</label>
		<select id="type">
			<option value="LineString">LineString</option>
		</select>
	</form>
	<span>
		<button id="set-source" class="code">시장 보여주세요~</button>
    	<button id="unset-source" class="code">시장 안볼래요</button>
    	<button id="set-mart" class="code">마트 보여주세요~</button>
    	<button id="unset-mart" class="code">마트 안볼래요</button>
    	<button id="set-cafe" class="code">카페 보여주세요~</button>
    	<button id="unset-cafe" class="code">카페 안볼래요</button>
	</span>
	
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
	
	var Draw = ol.interaction.Draw;
	var Overlay = ol.Overlay;
	var OSM = ol.source;
	var TileLayer = ol.layer.Tile;
	var {getArea, getLength} = ol.sphere;
	var {unByKey} = ol.Observable;
	var {get} = ol.proj;
	
	//시장 피쳐 생성
	var market1 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([126.97, 37.56])),
		name: '시장1'
	});
	var market2 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([126.98, 37.562])),
		name: '시장2'
	});
	var market3 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([126.9167, 37.5472])),
		name: '시장3'
	});
	var market4 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([126.9223, 37.5235])),
		name: '시장4'
	});
	var market5 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([126.8860, 37.5045])),
		name: '시장5'
	});
	var market6 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([126.9662, 37.4976])),
		name: '시장6'
	});
	
	//마트 피쳐 생성
	var mart1 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([127.0347, 37.5253])),
		name: '마트1'
	});
	var mart2 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([127.0570, 37.5060])),
		name: '마트2'
	});
	var mart3 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([127.0427, 37.47])),
		name: '마트3'
	});
	var mart4 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([127.1130, 37.5108])),
		name: '마트4'
	});
	var mart5 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([127.1516, 37.5502])),
		name: '마트5'
	});
	var mart6 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([127.0809, 37.5310])),
		name: '마트6'
	});
	
	/* //마트 피쳐 담아두는 소스 생성, 피쳐 담기
	const martSource = new VectorSource({
		features: [mart1, mart2, mart3, mart4, mart5, mart6]
	});

	//마트 벡터 레이어 생성
	const mart = new VectorLayer({
		name: 'mart',
	 	source: martSource,
	  	style: new Style({
		  	image: new CircleStyle({
		      	radius: 5,
		      	fill: new Fill({color: '#1844af'}),
		      	stroke: new Stroke({color: '#000000', width: 0.6})
		    })
		})
	}); */
	
	//카페 피쳐 생성
	var cafe1 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([127.1463, 37.5882])),
		name: '카페1'
	});
	var cafe2 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([127.0805, 37.5795])),
		name: '카페2'
	});
	var cafe3 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([127.0797, 37.5942])),
		name: '카페3'
	});
	var cafe4 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([127.0370, 37.6086])),
		name: '카페4'
	});
	var cafe5 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([126.9976, 37.5619])),
		name: '카페5'
	});
	var cafe6 = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([127.0196, 37.5945])),
		name: '카페6'
	});
	
	/* //카페 피쳐 담아두는 소스 생성, 피쳐 담기
	const cafeSource = new VectorSource({
		features: [cafe1, cafe2, cafe3, cafe4, cafe5, cafe6]
	});

	//카페 벡터 레이어 생성
	const cafe = new VectorLayer({
		name: 'cafe',
	 	source: cafeSource,
	  	style: new Style({
		  	image: new CircleStyle({
		      	radius: 5,
		      	fill: new Fill({color: '#fef33f'}),
		      	stroke: new Stroke({color: '#000000', width: 0.6})
		    })
		})
	}); */
	
	//시장 피쳐 담아두는 소스 생성, 피쳐 담기
	const marketSource = new VectorSource({
		features: [
			market1, market2, market3, market4, market5, market6, 
			mart1, mart2, mart3, mart4, mart5, mart6,
			cafe1, cafe2, cafe3, cafe4, cafe5, cafe6
			]
	});
	
	const market = new VectorLayer({
		name: 'market',
	 	source: marketSource,
	  	style: new Style({})
	});
	
	//경로선 벡터 레이어 생성
	const styleFunction = function (feature) {
		const geometry = feature.getGeometry();
  		const styles = [
    		// linestring
    		new Style({
      			stroke: new Stroke({
        			color: '#ffcc33',
        			width: 2,
      			}),
    		}),
  		];

	  	geometry.forEachSegment(function (start, end) {
	    	const dx = end[0] - start[0];
	    	const dy = end[1] - start[1];
	    	const rotation = Math.atan2(dy, dx);
	    	// arrows
	    	/* styles.push(
	      		new Style({
	        		geometry: new Point(end),
	        		image: new Icon({
	          			src: 'data/arrow.png',
	          			anchor: [0.75, 0.5],
	          			rotateWithView: true,
	          			rotation: -rotation,
	        		}),
	      		})
	    	); */
	  	});
		return styles;
	};
	const drawingLine = new VectorLayer({
		source: new VectorSource(),
		style: styleFunction,
	});

	//배경지도 레이어 생성
	const baseMap = new ol.layer.Tile({
		source: new ol.source.OSM({
			url : 'https://{a-c}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png'
		})
	});
	
	const mapOverlay = new ol.Overlay(({ element: container }));
		
	const extent = get('EPSG:3857').getExtent().slice();
	extent[0] += extent[0];
	extent[2] += extent[2];

	//지도 객체에 레이어 지정 
	const map = new ol.Map({
		// TODO : 삭제
	  //layers: [baseMap, market, mart, cafe, drawingLine],
	  layers: [baseMap, market, drawingLine],
	  overlays: [mapOverlay],
	  target: document.getElementById('map'), //지도를 표현할 div 요소를 지정 
	  view: new ol.View({
	    center: ol.proj.fromLonLat([126.9784147, 37.5666805]),  //초기 중심 좌표 
	    zoom: 12,
	    minZoom:7,
	    maxZoom:19,
	    extent,
	  })
	});
	
	//시설마다 다른색상 입히기
	for (var i = 0; i < market.getSource().getFeatures().length; i++) {
		var name = market.getSource().getFeatures()[i].A.name.substring(0,2);

		var color1;
		
		if (name == '마트') {
			color1 = '#1844af';
		} else if (name == '시장') {
			color1 = '#ff3700';
		} else {
			color1 = '#fef33f';
		}
		
		var style2 = new Style({
		  	image: new CircleStyle({
		      	radius: 5,
		      	fill: new Fill({color: color1}),
		      	stroke: new Stroke({color: '#000000', width: 0.6})
		    })
		});
		
		market.getSource().getFeatures()[i].setStyle(style2);
	}
	
	//시설 피쳐포인트 온오프 기능
	document.getElementById('set-source').onclick = function () {
		for (var i = 0; i < market.getSource().getFeatures().length; i++) {
			var name = market.getSource().getFeatures()[i].A.name.substring(0,2);
			if (name == '시장') {
				var style = new Style({
					image: new CircleStyle({
				      	radius: 5,
				      	fill: new Fill({color: '#ff3700'}),
				      	stroke: new Stroke({color: '#000000', width: 0.6})
				    })	
				});
				market.getSource().getFeatures()[i].setStyle(style);
			}
		}
	};
	
	document.getElementById('unset-source').onclick = function () {
		for (var i = 0; i < market.getSource().getFeatures().length; i++) {
			var name = market.getSource().getFeatures()[i].A.name.substring(0,2);
			if (name == '시장') {
				market.getSource().getFeatures()[i].setStyle(null);
			}
		}
	};
	
	document.getElementById('set-mart').onclick = function () {
		for (var i = 0; i < market.getSource().getFeatures().length; i++) {
			var name = market.getSource().getFeatures()[i].A.name.substring(0,2);
			if (name == '마트') {
				var style = new Style({
					image: new CircleStyle({
				      	radius: 5,
				      	fill: new Fill({color: '#1844af'}),
				      	stroke: new Stroke({color: '#000000', width: 0.6})
				    })	
				});
				market.getSource().getFeatures()[i].setStyle(style);
			}
		}
	};
	
	document.getElementById('unset-mart').onclick = function () {
		for (var i = 0; i < market.getSource().getFeatures().length; i++) {
		var name = market.getSource().getFeatures()[i].A.name.substring(0,2);
			if (name == '마트') {
				market.getSource().getFeatures()[i].setStyle(null);
			}
		}
	};
	
	document.getElementById('set-cafe').onclick = function () {
		for (var i = 0; i < market.getSource().getFeatures().length; i++) {
			var name = market.getSource().getFeatures()[i].A.name.substring(0,2);
			if (name == '카페') {
				var style = new Style({
					image: new CircleStyle({
				      	radius: 5,
				      	fill: new Fill({color: '#fef33f'}),
				      	stroke: new Stroke({color: '#000000', width: 0.6}),
				    })	
				});
				market.getSource().getFeatures()[i].setStyle(style);
			}
		}
	};
	
	document.getElementById('unset-cafe').onclick = function () {
		for (var i = 0; i < market.getSource().getFeatures().length; i++) {
		var name = market.getSource().getFeatures()[i].A.name.substring(0,2);
			if (name == '카페') {
				market.getSource().getFeatures()[i].setStyle(null);
			}
		}
	};
	//시설 피쳐포인트 온오프 기능 끝
	
	//경로그리기, 거리 계산 시작
	let sketch;
	let helpTooltipElement;
	let helpTooltip;
	let measureTooltipElement;
	let measureTooltip;
	const continueLineMsg = '경로그리기를 끝내려면 더블클릭하세용';
	
	const pointerMoveHandler = function(evt){
		if(evt.dragging){
			return;
		}
		let helpMsg = '경로그리기를 시작하려면 클릭하세용';
		if(sketch){
			const geom = sketch.getGeometry();
			if(geom instanceof LineString){
				helpMsg=continueLineMsg;
			}
		}
		helpTooltipElement.innerHTML = helpMsg;
		helpTooltip.setPosition(evt.coordinate);
		helpTooltipElement.classList.remove('hidden');
	}
	
	map.on('pointermove', pointerMoveHandler);
	map.getViewport().addEventListener('mouseout', function(){
		helpTooltipElement.classList.add('hidden');
	});
	
	const typeSelect = document.getElementById('type');
	let draw;

	const formatLength = function(line){
		const length = getLength(line);
		let output;
		if(length>100){
			output = Math.round((length/1000)*100)/100 + '' + 'km';
		}else{
			output = Math.round(length*100)/100 + '' + 'm';
		}
		return output;
	}
	
	function addInteraction(){
		draw = new Draw({
			source: new VectorSource(),
			type: 'LineString',
			style: new Style({
				fill: new Fill({
					color: 'rgba(255, 255, 255, 0.2)',
				}),
				stroke: new Stroke({
			        color: 'rgba(0, 0, 255, 0.5)',
			        lineDash: [10, 5],
			        width: 2,
			    }),
			    image: new CircleStyle({
			    	radius: 5,
			        stroke: new Stroke({
			          color: 'rgba(0, 0, 0, 0.7)',
			        }),
			        fill: new Fill({
			          color: 'rgba(255, 255, 255, 0.2)',
			        }),
			    }),
			}),
		});
		map.addInteraction(draw);
		createMeasureTooltip();
		createHelpTooltip();
		
		let listener;
		draw.on('drawstart', function(evt){
			sketch = evt.feature;
			let tooltipCood = evt.coordinate;
			listener = sketch.getGeometry().on('change', function(evt){
				const geom = evt.target;
				let output;
				if(geom instanceof LineString) {
					output = formatLength(geom);
					tooltipCoord = geom.getLastCoordinate();
				}
				measureTooltipElement.innerHTML = output;
				measureTooltip.setPosition(tooltipCoord);
			});
		});
		
		draw.on('drawend', function(evt){
			measureTooltipElement.className = 'ol-tooltip ol-tooltip-static';
			measureTooltip.setOffset([0, -7]);
			//unset sketch
			sketch = null;
			//unset tooltip so that a new one can be created
			measureTooltipElement = null;
		    createMeasureTooltip();
		    unByKey(listener);
		})
	}
	
	//creates a new help tooltip
	function createHelpTooltip(){
		if(helpTooltipElement){
			helpTooltipElement.parentNode.removeChild(helpTooltipElement);
		}
		helpTooltipElement = document.createElement('div');
			helpTooltipElement.className = 'ol-tooltip hidden';
			helpTooltip = new Overlay({
		    	element: helpTooltipElement,
		    	offset: [15, 0],
		    	positioning: 'center-left',
		  	});
		map.addOverlay(helpTooltip);
	}
	
	//creates a new measure tooltip
	function createMeasureTooltip() {
  		if (measureTooltipElement) {
    		measureTooltipElement.parentNode.removeChild(measureTooltipElement);
  		}
  		measureTooltipElement = document.createElement('div');
  		measureTooltipElement.className = 'ol-tooltip ol-tooltip-measure';
  		measureTooltip = new Overlay({
    		element: measureTooltipElement,
    		offset: [0, -15],
    		positioning: 'bottom-center',
    		stopEvent: false,
    		insertFirst: false,
  		});
  		map.addOverlay(measureTooltip);
	}
	
	addInteraction();
	//경로그리기, 거리 계산 끝
	
	//마우스 커서 위치에 대한 지도 좌표를 받아, 가까운 피쳐를 찾아 피드백 시각화 하는 함수(displaySnap) 선언
	let point = null;
	let line = null;
	var layers;
	const displaySnap = function (coordinate) {
		/*var tempSource = new VectorSource();
		layers.forEach(function(layer){
			marketSource.addFeatures(layer.getSource().getFeatures());
			martSource.addFeatures(layer.getSource().getFeatures());
			cafeSource.addFeatures(layer.getSource().getFeatures());
		});*/
	  const closestFeature = marketSource.getClosestFeatureToCoordinate(coordinate);
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
	  //커서가 피쳐 위에 있을 경우 포인터 아이콘으로 변경
	  var pixel = map.getEventPixel(evt.originalEvent);
	  var marketcursor = map.hasFeatureAtPixel(evt.pixel, {
		  layerFilter: function(layer){
			  return layer.get('name') === 'market';
		  }
		});
	  map.getTargetElement().style.cursor = marketcursor ? 'pointer': '';
	  //커서에 피쳐가 없을 경우
	  if(hover!=null){
		  hover=null;
		}
	  //커서에 있는 피쳐 hover에 저장
	  map.forEachFeatureAtPixel(evt.pixel, function(f) {
			hover = f;
			return true;
		}, {layerFilter: function(layer){
			return layer === market;	
		}
		});
		//피쳐가 있을 경우
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

	//가까운 피쳐와 연결되는 라인 스타일 
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

	//가까운 피쳐와 연결되는 라인 그려주기
	market.on('postrender', function (evt) {
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
