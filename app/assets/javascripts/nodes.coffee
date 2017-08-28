# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("#map").ready ->
    $.getJSON(url: "/nodes/heatmap.json").done (json) ->
      heatmapData = [];
      $.each json, (i, field) ->
        latLng = new google.maps.LatLng(field[1], field[0]);
        heatmapData.push(latLng);
        return
      heatmap = new google.maps.visualization.HeatmapLayer({
        data: heatmapData,
        radius: 20,
        gradient: ["rgba(0,0,0,0)","rgba(155,237,244,0.9)","rgba(155,237,244,1)","rgba(120,178,215,0.9)","rgba(120,178,215,1)","rgba(92,130,192,0.9)","rgba(92,130,192,1)","rgba(133,79,190,0.9)","rgba(133,79,190,1)","rgba(92,29,156,0.9)","rgba(92,29,156,1)"]
      });
      heatmap.setMap(map);
      # heatmap.set('radius', 20);

