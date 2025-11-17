# Create an empty leaflet map from sf input

Create an empty leaflet map from sf input

## Usage

``` r
util_map(tomap, minimap = "bottomleft")
```

## Arguments

- tomap:

  `sf` input object

- minimap:

  character string indicating location of minimap, use `minimap = NULL`
  to suppress

## Value

A `leaflet` object with optional minimap and ESRI provider tiles

## Examples

``` r
tomap <- tibble::tibble(
  lon = -82.6365,
  lat = 27.75822
  )
tomap <- sf::st_as_sf(tomap, coords = c('lon', 'lat'), crs = 4326)
util_map(tomap)

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"fitBounds":[27.75822,-82.6365,27.75822,-82.6365,[]],"calls":[{"method":"addProviderTiles","args":["Esri.WorldGrayCanvas",null,"Esri.WorldGrayCanvas",{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addProviderTiles","args":["Esri.NatGeoWorldMap",null,"Esri.NatGeoWorldMap",{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addProviderTiles","args":["Esri.OceanBasemap",null,"Esri.OceanBasemap",{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addProviderTiles","args":["Esri.WorldPhysical",null,"Esri.WorldPhysical",{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addProviderTiles","args":["Esri.WorldShadedRelief",null,"Esri.WorldShadedRelief",{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addProviderTiles","args":["Esri.WorldTerrain",null,"Esri.WorldTerrain",{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addProviderTiles","args":["Esri.WorldImagery",null,"Esri.WorldImagery",{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addProviderTiles","args":["Esri.WorldTopoMap",null,"Esri.WorldTopoMap",{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addProviderTiles","args":["Esri.DeLorme",null,"Esri.DeLorme",{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addProviderTiles","args":["Esri.WorldStreetMap",null,"Esri.WorldStreetMap",{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addProviderTiles","args":["Esri",null,"Esri",{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addLayersControl","args":[["Esri.WorldGrayCanvas","Esri.NatGeoWorldMap","Esri.OceanBasemap","Esri.WorldPhysical","Esri.WorldShadedRelief","Esri.WorldTerrain","Esri.WorldImagery","Esri.WorldTopoMap","Esri.DeLorme","Esri.WorldStreetMap","Esri"],[],{"collapsed":true,"autoZIndex":true,"position":"topleft"}]},{"method":"addMiniMap","args":[null,"Esri.WorldGrayCanvas","bottomleft",150,150,19,19,-5,false,false,false,true,false,true,{"color":"#ff7800","weight":1,"clickable":false},{"color":"#000000","weight":1,"clickable":false,"opacity":0,"fillOpacity":0},{"hideText":"Hide MiniMap","showText":"Show MiniMap"},[]]}]},"evals":[],"jsHooks":{"render":[{"code":"function(el, x, data) {\n  return (\n      function(el, x) {\n        var myMap = this;\n        myMap.on('baselayerchange',\n          function (e) {\n            myMap.minimap.changeLayer(L.tileLayer.provider(e.name));\n          })\n      }).call(this.getMap(), el, x, data);\n}","data":null}]}}
```
