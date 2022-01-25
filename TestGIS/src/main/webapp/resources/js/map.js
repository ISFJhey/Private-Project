var map, baseMap, olview, spread_accident_layer, road_layer, current_pos_Layer, accident_pos_Layer, destination_pos_Layer, umd_layer;
var spread_accident_heatmap_blur = 60;
var spread_accident_heatmap_radius = 10;

var ServerUrl = "http://192.168.0.7:3004/MapPrimeServer";

var result_bool = false;
var timeClick_bool = false;

var windy;
var canvas;
var accident_alarm, accident_running_time;
var accident_alarm_cnt = 0 ;	
var accident_task = 1;
var currentTime;

$(function(){
	
	//proj4.defs("EPSG:5179", "+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs");
	
	baseMap = new ol.layer.Tile({
		source: new ol.source.XYZ({
			url: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
		})
	});
	
	var overviewMap = new ol.control.OverviewMap({
		className: 'ol-overviewmap ol-custom-overviewmap',
		layers: [baseMap],
		collapseLabel: '\u00BB',
		label: '\u00AB',
		collapsed: false
	});
	
	var scaleLine = new ol.control.ScaleLine();
	
	var mousePosition = new ol.control.MousePosition({
		undefinedHTML: '',
		projection: 'EPSG:4326',
		coordinateFormat: function(coordinate) {
            return ol.coordinate.format(coordinate, '{x}, {y}', 4);
        }
	});
	
	var zoomslider = new ol.control.ZoomSlider();
	
	olview = new ol.View({
		center: ol.proj.transform([127.07411741084566, 37.15886078613144], 'EPSG:4326', 'EPSG:3857'),
		zoom: 7,
        minZoom: 1,
        maxZoom: 18
	});
	 
	map = new ol.Map({
		target: 'map',
		layers: [baseMap],
		interactions: ol.interaction.defaults({
		}),
		view: olview,
		controls: ol.control.defaults({
			attribution: false
		}).extend([overviewMap, scaleLine, mousePosition, zoomslider])
	});
	
	var highlightedFeatures = [],
	  selectStyle = new ol.style.Style({
	    stroke: new ol.style.Stroke({
	      color: '#0d47a1',
	      width: 2
	    }),
	    image: new ol.style.Circle({
	      radius: 5.5,
	      stroke: new ol.style.Stroke({
	        color: '#0d47a1',
	        width: 2
	      })
	    })
	  });
	
	var keydown = function(evt){
	    var charCode = (evt.which) ? evt.which : evt.keyCode;
	    if (charCode == 49 || charCode == 97) {
			//alert('사고발생');
	    	
	    	if(!accident_alarm){
		    	accident_alarm = setInterval(function() {
		    		if(accident_alarm_cnt < 3){
		    			$('#alarm-dim-layer').fadeOut('fast').fadeIn('fast');
		    		}
		    		
		    		accident_alarm_cnt++;
		    		if(accident_alarm_cnt == 4){
		    			clearInterval(accident_alarm);
		    			
		    			//경고 Layer 감추기
		    			$('.dim-layer').hide();
		    			
		    			//확산예상범위 text
		    			$('#accident_area1').text('(심각) 발생 즉시 (약 100M)');
		    			$('#accident_area2').text('(경계) 10분 후 (약 0.9Km)');
		    			$('#accident_area3').text('(주의) 1시간 후 (약 1.9Km)');
		    			
		    			//현재위치 마커
		    			pan(14144142.43805873, 4461322.092581252);
		    			//사고위치 마커
		    			mark_accident_pos();
		    			
		    			//사고정보 Layer
		    			currentTime = new Date();
		    			$('#currentTime h4').text(currentTime.getHours() + ':' + checkTime(currentTime.getMinutes()) + ':' + checkTime(currentTime.getSeconds()));
		    			
		    			accident_running_time = setInterval(function() {
		    				var newTime = new Date().getTime()-currentTime.getTime();
		    				$('#runningTime h4').text(checkTime(parseInt(newTime/1000/60/60)) + ':' + checkTime(parseInt(newTime/1000/60)) + ':' + checkTime(parseInt((newTime/1000) % 60)) + ' (진행 중)');
		    			},1000);
		    			
		    			$('#pixel_box1').show();
		    			//대응상황 Layer
		    			$('#pixel_box2').show();
		    			//지도 on/off창
		    			$('#pixel_box4').show();
		    			
		    			//사고확산 Layer
		    			spread_accident();
		    			//대피소 안내 전체 선택
		    			$('#pills-all-tab').click();
		    			//우측패널 닫혀있을경우 open
		    			if($('.hamburger').hasClass('is-open') == false){
		    				$('.hamburger').click();
		    			}
		    			
		    			//기본 text 셋팅
		    			$('#address').text('경기도 오산시 은여울로 29');
		    			$('#accident').append('<img src="resources/images/accident_pos.png" style="width:30px; height:30px; margin-right:5px;">경기도 오산시 경기동로 33');
		    			$('#accidentMatrial').text('염화티오닐(Thionyl chloride)');
		    			
		    			fetch('resources/data/wind-gfs.json').then(function(response) {
		    				return response.json();
		    			}).then(function(json) {
		    				windy = new Windy({canvas: canvas, data: json });
		    				refreshWindy();
		    			});
		    		}
		    		 
		    	},1500);
	    	}


	    }else if (charCode == 50 || charCode == 98) {
	
	    	if(accident_task == 1){
	    		accident_task = 2;
	    		$('.item:eq(4)').css('background-color', '#6d6767')
		    	$('.item:eq(6)').css('background-color', '#d9534f')
		    	
	    	}else if(accident_task == 2){
	    		accident_task = 3;
	    		$('.item:eq(6)').css('background-color', '#6d6767')
		    	$('.item:eq(8)').css('background-color', '#d9534f')

	    	}else if(accident_task == 3){
	    		accident_task = 4;
	    		$('.item:eq(8)').css('background-color', '#6d6767')
		    	$('.item:eq(10)').css('background-color', '#d9534f')
		    	
	    	}else if(accident_task == 4){
	    		accident_task = 1;
	    		$('.item:eq(10)').css('background-color', '#6d6767')
		    	$('.item:eq(4)').css('background-color', '#d9534f')
	    	}
	    	
	    }else if (charCode == 51 || charCode == 99) {
	    	umd_layer_add();	
	    }else if (charCode == 52 || charCode == 100) {
	    	spread_accident();	
	    }
	};
	
	document.addEventListener('keydown', keydown, false);
	
	map.getView().on('change:resolution', function(evt){
		if(typeof spread_accident_layer!="undefined"){
			spread_accident_layer.setBlur(parseInt(376/parseInt(map.getView().getResolution())));
			spread_accident_layer.setRadius(parseInt(72/parseInt(map.getView().getResolution())));
		}
	});




	var selectSingleClick = new ol.interaction.Select();
	map.addInteraction(selectSingleClick);


	map.on('singleclick', function(event){  
    	road_layer.once('precompose',function(event){
      		var selectedFeatures = selectSingleClick.getFeatures();
      		readFeature(selectedFeatures);
    	});
	});

	function readFeature(features){
		var myfeature = features.item(0);
		alert(myfeature.getId());
	}


	
/**
	map.on('click', function (e) {
		var coord = map.getCoordinateFromPixel(e.pixel);
		var cord1 = ol.proj.transform(coord, 'EPSG:3857', 'EPSG:4326');
		alert(cord1[0] + ", " + cord1[1]);
	});
*/
	
	canvas = document.getElementById('windyMap');

	
	$('#map_onoff_spread').on('click', function(e){
		if($('#map_onoff_spread').hasClass('btn-success') == true){
			$('#map_onoff_spread').removeClass('btn-success');
			$('#map_onoff_spread').addClass('btn-danger');
			$('#map_onoff_spread').text('확산 Map off');
			if(typeof spread_accident_layer!="undefined"){
				spread_accident_layer.setVisible(false);
			}
		}else{
			$('#map_onoff_spread').removeClass('btn-danger');
			$('#map_onoff_spread').addClass('btn-success');
			$('#map_onoff_spread').text('확산 Map on');
			if(typeof spread_accident_layer!="undefined"){
				spread_accident_layer.setVisible(true);
			}
		}
	});
	
	$('#map_onoff_wind').on('click', function(e){
		if($('#map_onoff_wind').hasClass('btn-success') == true){
			$('#map_onoff_wind').removeClass('btn-success');
			$('#map_onoff_wind').addClass('btn-danger');
			$('#map_onoff_wind').text('바람 Map off');
			refreshWindy('stop');
		}else{
			$('#map_onoff_wind').removeClass('btn-danger');
			$('#map_onoff_wind').addClass('btn-success');
			$('#map_onoff_wind').text('바람 Map on');
			refreshWindy('start');
		}
	});
	
});


function pan(x, y){
	
	var location = [Number(x),Number(y)];
	
	location_maker(location);
	
	olview.animate({
		center: location,
        duration: 2000
	});
	olview.animate({
		zoom: olview.getZoom(),
        duration: 1000
	}, {
		zoom: 14,
        duration: 1000
	});

}

function location_maker(xy, gbn){

	var imgsrc = 'resources/images/current_location.png';

	if(gbn == 'normal'){
		//안전지역
		imgsrc = 'resources/images/safe_place.png';
	}else if(gbn == 'rapid'){
		//긴급대피
		imgsrc = 'resources/images/rapid_place.png';
	}
	
	
	if(typeof markerLayer!="undefined"){
		map.removeLayer(markerLayer);
	}
	
	var iconFeature = new ol.Feature({
		geometry: new ol.geom.Point(xy)
	});
	
	var iconStyle = new ol.style.Style({
		image: new ol.style.Icon(({
			scale: 0.5,
	        anchor: [0.5, 64],
	        anchorXUnits: 'fraction',
	        anchorYUnits: 'pixels',
			src: imgsrc
        }))
	});

	iconFeature.setStyle(iconStyle);

	var vectorSource = new ol.source.Vector({
		features: [iconFeature]
	});

	markerLayer = new ol.layer.Vector({
		source: vectorSource,
		zIndex: 2
	});
	
	map.addLayer(markerLayer);
}

function destination_center_mov(id){
	var location;

	var feature;
	
	if(id == 'r1'){
		feature = new ol.Feature({
			geometry: new ol.geom.Point([[Number(14143605.587367889), Number(4461828.48825813)], [Number(14144142.43805873), Number(4461322.092581252)]])
		});
		
	}else if(id == 'r2'){
		feature = new ol.Feature({
			geometry: new ol.geom.Point([[Number(14144142.43805873), Number(4461322.092581252)], [Number(14143548.856715363), Number(4460781.857910858)]])
		});
		
	}else if(id == 'r3'){
		feature = new ol.Feature({
			geometry: new ol.geom.Point([[Number(14144142.43805873), Number(4461322.092581252)], [Number(14143141.38648205), Number(4463509.717837235)]])
		});
		
	}else if(id == 'n1'){
		feature = new ol.Feature({
			geometry: new ol.geom.Point([[Number(14144142.43805873), Number(4461322.092581252)], [Number(14143116.509783242), Number(4459157.969053901)]])
		});
		
	}else if(id == 'n2'){
		feature = new ol.Feature({
			geometry: new ol.geom.Point([[Number(14144142.43805873), Number(4461322.092581252)], [Number(14142972.991312595), Number(4464819.883014438)]])
		});
	}
	
	map.getView().fit(getExtentOfCoord(feature.getGeometry().getCoordinates()), {size:map.getSize(), maxZoom:16, duration: 1000});
}

function getCenterOfCoord(coord){
	
	var x = Math.abs(coord[0][0] - (coord[0][0] - coord[1][0])/2);
	var y =	Math.abs(coord[0][1] - (coord[0][1] - coord[1][1])/2);
	
	return [x, y];
}


function getExtentOfCoord(coord){
	
	var minx = (coord[0][0] >= coord[1][0])?coord[1][0]:coord[0][0]; 
	var maxx = (coord[0][0] >= coord[1][0])?coord[0][0]:coord[1][0];
	var miny = (coord[0][1] >= coord[1][1])?coord[1][1]:coord[0][1];
	var maxy = (coord[0][1] >= coord[1][1])?coord[0][1]:coord[1][1];
	
	return [minx, miny, maxx, maxy];
}


//accident layer
function spread_accident(){

	if(typeof spread_accident_layer=="undefined"){

		spread_accident_layer = new ol.layer.Heatmap({
			source: new ol.source.Vector({
				url: ServerUrl + 'map/wfs?SERVICE=WFS&REQUEST=GetFeature&TYPENAME=tilemaker:accspred&VERSION=1.0.0&OUTPUTFORMAT=application/json',
				format: new ol.format.GeoJSON()
			}),
			blur: 42,
			radius: 8,
			zIndex: 1,
			minResolution:2,
			maxResolution:20,
			//gradient: ['#00f', '#0ff', '#0f0', '#ff0', '#f00'],
			gradient: ['#0f0', '#0f0', '#ff0', '#ff0', '#f00'],
			//extent: [14141835.39333435, 4463321.000517107, 14147353.19169639, 4460394.099211825]
		});

		map.addLayer(spread_accident_layer);
	}else{
		if(spread_accident_layer.getVisible() == true ){
			spread_accident_layer.setVisible(false);
			
		}else{
			spread_accident_layer.setVisible(true);
		}

	}
}


function umd_layer_add(){
	
	if(typeof umd_layer=="undefined"){
		umd_layer = new ol.layer.Image({
			source: new ol.source.ImageWMS({
				ratio: 1,
				url: ServerUrl + 'map/wms',
				params: {
					FORMAT: 'image/png',
					VERSION: '1.1.1',
					tiled: true,
					STYLES: '',
					LAYERS: 'tilemaker:tl_scco_emd',
				},
				projection: 'EPSG:3857'
			}),
			opacity: 0.7,
			zIndex: 1
		});

		map.addLayer(umd_layer);
		
	}else{
		if(umd_layer.getVisible() == true ){
			umd_layer.setVisible(false);
			
		}else{
			umd_layer.setVisible(true);
		}

	}
}



//wind layer
function refreshWindy(bool) {
	if(!windy) return;
	windy.stop();
	var mapSize = map.getSize();
	var extent = map.getView().calculateExtent(mapSize);
	extent = ol.proj.transformExtent(extent, 'EPSG:3857', 'EPSG:4326');

	canvas.width = mapSize[0];
	canvas.height = mapSize[1];

	if(bool == 'stop'){
		windy.start(
				[[0,0], [0, 0]],
				0,
				0,
				[[147.5524902082155, 39.05183780640292],[147.7722167707155, 39.13727434118336]]
		);
	  
	}else{
		windy.start(
				[[0,0], [canvas.width, canvas.height]],
				canvas.width,
				canvas.height,
				//[[extent[0], extent[1]],[extent[2], extent[3]]]
				[[147.5524902082155, 39.05183780640292],[147.7722167707155, 39.13727434118336]]
		);
	}
}

function mark_accident_pos(){
	
	if(accident_pos_Layer){
		map.removeLayer(accident_pos_Layer);
	}

	var iconStyle = new ol.style.Style({
		image: new ol.style.Icon(({
	        scale: 0.5,
	        anchor: [0.5, 16],
	        anchorXUnits: 'fraction',
	        anchorYUnits: 'pixels',
	        src: 'resources/images/accident_pos.png',
	        color: '#8959A8'
        }))
	});
	
	var iconFeature = new ol.Feature({
		geometry: new ol.geom.Point([Number(14145811.313953847),Number(4461549.811033628)])
	});

	iconFeature.setStyle(iconStyle);
	var vectorSource = new ol.source.Vector();
	vectorSource.addFeature(iconFeature);
	
	accident_pos_Layer = new ol.layer.Vector({
		source: vectorSource,
		zIndex: 2
	});
	
	map.addLayer(accident_pos_Layer);
}

function shelter_mark(gbn){

	if(destination_pos_Layer){
		map.removeLayer(destination_pos_Layer);
	}

	if(road_layer){
		map.removeLayer(road_layer);
	}

	var stroke = new ol.style.Stroke({
		   color: '#3399CC',
		   width: 1.25
		 });
	 
	var iconStyle1 = new ol.style.Style({
		image: new ol.style.Icon(({
			scale: 0.5,
			anchor: [0.5, 16],
			anchorXUnits: 'fraction',
			anchorYUnits: 'pixels',
	        src: 'resources/images/safe_place.png'
        }))
	});

	var iconStyle2 = new ol.style.Style({
		image: new ol.style.Icon(({
			scale: 0.5,
			anchor: [0.5, 16],
			anchorXUnits: 'fraction',
			anchorYUnits: 'pixels',
	        src: 'resources/images/rapid_place.png'
        }))
	});

	var iconFeature1 = new ol.Feature({
		geometry: new ol.geom.Point([Number(14143605.587367889),Number(4461828.48825813)])
	});
	iconFeature1.setStyle(iconStyle2);

	var iconFeature2 = new ol.Feature({
		geometry: new ol.geom.Point([Number(14143547.110123022),Number(4460780.265715782)])
	});
	iconFeature2.setStyle(iconStyle2);

	var iconFeature3 = new ol.Feature({
		geometry: new ol.geom.Point([Number(14143170.403291104),Number(4463524.518019678)])
	});
	iconFeature3.setStyle(iconStyle2);

	var iconFeature4 = new ol.Feature({
		geometry: new ol.geom.Point([Number(14143117.549268091),Number(4459159.9601543415)])
	});
	iconFeature4.setStyle(iconStyle1);

	var iconFeature5 = new ol.Feature({
		geometry: new ol.geom.Point([Number(14142975.026447874),Number(4464810.726689826)])
	});
	iconFeature5.setStyle(iconStyle1);

	
	var vectorSource = new ol.source.Vector();
	
	if(gbn == 'all'){
		vectorSource.addFeature(iconFeature1);
		vectorSource.addFeature(iconFeature2);
		vectorSource.addFeature(iconFeature3);
		vectorSource.addFeature(iconFeature4);
		vectorSource.addFeature(iconFeature5);
		
	}else if(gbn == 'normal'){
		vectorSource.addFeature(iconFeature4);
		vectorSource.addFeature(iconFeature5);
		
	}else if(gbn == 'rapid'){
		vectorSource.addFeature(iconFeature1);
		vectorSource.addFeature(iconFeature2);
		vectorSource.addFeature(iconFeature3);
		
	}
	
	destination_pos_Layer = new ol.layer.Vector({
		source: vectorSource,
		zIndex: 2
	});
	
	map.addLayer(destination_pos_Layer);
}


function findroad(id, view){
	
	if(road_layer){
		map.removeLayer(road_layer);
		if(!view) return;
	}

	var roadSource;
	var feature;
	var reqid;	
	if(id == 'r1'){
		reqid = 1;
	}else if(id == 'r2'){
		reqid = 2;
	}else if(id == 'r3'){
		reqid = 3;
	}else if(id == 'n1'){
		reqid = 4;
	}
	
	if(id != 'n2'){
		roadSource = new ol.source.Vector({
	    	format: new ol.format.GeoJSON(),
	    	url: function (extent) {
	        	var strUrl = ServerUrl + 'map/wfs?SERVICE=WFS&REQUEST=GetFeature&TYPENAME=tilemaker:accroad&VERSION=1.0.0&outputFormat=application/json&featureid=accroad.' + reqid;
		        return strUrl;
	    	}
		});
	}else{
		feature = new ol.Feature({
	        geometry: new ol.geom.LineString([
		    	[14144142.43805873, 4461322.092581252],[14143993.545000171, 4461413.259601108],[14143911.534487171, 4461458.644086652],[14143449.125130663, 4461463.036704018],[14143435.589431202, 4461967.839620842],[14143408.517959384, 4462008.446810342],[14143394.5841747, 4462786.750950777],[14143404.138803236, 4462824.9694649195],[14143398.565245626, 4463033.578842468],[14143361.14293838, 4463172.91716313],[14143322.924424235, 4463254.927749026],[14143213.449585572, 4463410.575196084],[14143829.72312612, 4463834.163752129],[14143945.971155236, 4463987.0378086995],[14143627.483440185, 4464189.277494637],[14143226.18896879, 4464506.172650104],[14142972.991312595, 4464819.883014438]
				])
	    });
	    
	    roadSource = new ol.source.Vector();
	    roadSource.addFeature(feature);
	}
    
	road_layer = new ol.layer.Vector({
	    source: roadSource,
	    style: new ol.style.Style({
	        stroke: new ol.style.Stroke({
	            //color: 'rgba(0, 255, 0, 1.0)',
	        	color: 'rgba(255, 0, 0, 1.0)',
	            width: 4
	        }),
	        fill: new ol.style.Fill({
	            //color: 'rgba(0,255,0,0.4)'
	            color: 'rgba(255,0,0,0.4)'
	        })
	    })
	});
    
    map.addLayer(road_layer);
    
    destination_center_mov(id);
}

function checkTime(i) {
	if (i < 10) {
		i = "0" + i;
	}
	return i;
}