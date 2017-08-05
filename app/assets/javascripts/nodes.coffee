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
        radius: 20
      });
      heatmap.setMap(map);
      # heatmap.set('radius', 20);

