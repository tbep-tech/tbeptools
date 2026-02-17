# Plotly barplots of tidal creek context indicators

Plotly barplots of tidal creek context indicators

## Usage

``` r
show_tdlcrkindic(
  id,
  cntdat,
  yr = 2025,
  thrsel = FALSE,
  pal = c("#5C4A42", "#427355", "#004F7E")
)
```

## Arguments

- id:

  numeric indicating the `id` number of the tidal creek to plot

- cntdat:

  output from
  [`anlz_tdlcrkindic`](https://tbep-tech.github.io/tbeptools/reference/anlz_tdlcrkindic.md)

- yr:

  numeric indicating reference year

- thrsel:

  logical if threshold lines and annotations are shown on the plots

- pal:

  vector of colors for the palette

## Value

A plotly object

## Examples

``` r
cntdat <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2025)

set.seed(123)
id <- sample(unique(cntdat$id), 1)
show_tdlcrkindic(id, cntdat, thrsel = TRUE)

{"x":{"data":[{"x":["2016","2017","2018","2019","2020","2021","2022","2023","2024","2025"],"y":[0,0,0,2.8322078016562302,0,0,0,0,0,0],"text":[0,0,0,2.7999999999999998,0,0,0,0,0,0],"textposition":["auto","auto","auto","auto","auto","auto","auto","auto","auto","auto"],"marker":{"color":["#5C4A42","#585346","#545D4A","#4E664F","#476F53","#3F6F5A","#396763","#2F5F6C","#215775","#004F7E"],"line":{"color":"rgba(31,119,180,1)"}},"hoverinfo":["x","x","x","x","x","x","x","x","x","x"],"type":"bar","error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":["2016","2017","2018","2019","2020","2021","2022","2023","2024","2025"],"y":[0,0,0,1.02377496161778,0,0,0,0,0,0],"text":[0,0,0,1,0,0,0,0,0,0],"textposition":["auto","auto","auto","auto","auto","auto","auto","auto","auto","auto"],"marker":{"color":["#5C4A42","#585346","#545D4A","#4E664F","#476F53","#3F6F5A","#396763","#2F5F6C","#215775","#004F7E"],"line":{"color":"rgba(255,127,14,1)"}},"hoverinfo":["x","x","x","x","x","x","x","x","x","x"],"type":"bar","error_y":{"color":"rgba(255,127,14,1)"},"error_x":{"color":"rgba(255,127,14,1)"},"xaxis":"x2","yaxis":"y2","frame":null},{"x":["2016","2017","2018","2019","2020","2021","2022","2023","2024","2025"],"y":[0,0,0,2.7664358944476999,0,0,0,0,0,0],"text":[0,0,0,2.7999999999999998,0,0,0,0,0,0],"textposition":["auto","auto","auto","auto","auto","auto","auto","auto","auto","auto"],"marker":{"color":["#5C4A42","#585346","#545D4A","#4E664F","#476F53","#3F6F5A","#396763","#2F5F6C","#215775","#004F7E"],"line":{"color":"rgba(44,160,44,1)"}},"hoverinfo":["x","x","x","x","x","x","x","x","x","x"],"type":"bar","error_y":{"color":"rgba(44,160,44,1)"},"error_x":{"color":"rgba(44,160,44,1)"},"xaxis":"x","yaxis":"y3","frame":null},{"x":["2016","2017","2018","2019","2020","2021","2022","2023","2024","2025"],"y":[0,0,0,7.2480994677129704,0,0,0,0,0,0],"text":[0,0,0,7.2000000000000002,0,0,0,0,0,0],"textposition":["auto","auto","auto","auto","auto","auto","auto","auto","auto","auto"],"marker":{"color":["#5C4A42","#585346","#545D4A","#4E664F","#476F53","#3F6F5A","#396763","#2F5F6C","#215775","#004F7E"],"line":{"color":"rgba(214,39,40,1)"}},"hoverinfo":["x","x","x","x","x","x","x","x","x","x"],"type":"bar","error_y":{"color":"rgba(214,39,40,1)"},"error_x":{"color":"rgba(214,39,40,1)"},"xaxis":"x2","yaxis":"y4","frame":null},{"x":["2016","2017","2018","2019","2020","2021","2022","2023","2024","2025"],"y":[0,0,0,45.9492470780893,0,0,0,0,0,0],"text":[0,0,0,45.899999999999999,0,0,0,0,0,0],"textposition":["auto","auto","auto","auto","auto","auto","auto","auto","auto","auto"],"marker":{"color":["#5C4A42","#585346","#545D4A","#4E664F","#476F53","#3F6F5A","#396763","#2F5F6C","#215775","#004F7E"],"line":{"color":"rgba(148,103,189,1)"}},"hoverinfo":["x","x","x","x","x","x","x","x","x","x"],"type":"bar","error_y":{"color":"rgba(148,103,189,1)"},"error_x":{"color":"rgba(148,103,189,1)"},"xaxis":"x","yaxis":"y5","frame":null},{"x":["2016","2017","2018","2019","2020","2021","2022","2023","2024","2025"],"y":[0,0,0,0,0,0,0,0,0,0],"text":[0,0,0,0,0,0,0,0,0,0],"textposition":["auto","auto","auto","auto","auto","auto","auto","auto","auto","auto"],"marker":{"color":["#5C4A42","#585346","#545D4A","#4E664F","#476F53","#3F6F5A","#396763","#2F5F6C","#215775","#004F7E"],"line":{"color":"rgba(140,86,75,1)"}},"hoverinfo":["x","x","x","x","x","x","x","x","x","x"],"type":"bar","error_y":{"color":"rgba(140,86,75,1)"},"error_x":{"color":"rgba(140,86,75,1)"},"xaxis":"x2","yaxis":"y6","frame":null}],"layout":{"xaxis":{"domain":[0,0.46000000000000002],"automargin":true,"title":"","type":"category","categoryorder":"array","categoryarray":["2016","2017","2018","2019","2020","2021","2022","2023","2024","2025"],"anchor":"y5"},"xaxis2":{"domain":[0.54000000000000004,1],"automargin":true,"title":"","type":"category","categoryorder":"array","categoryarray":["2016","2017","2018","2019","2020","2021","2022","2023","2024","2025"],"anchor":"y6"},"yaxis6":{"domain":[0,0.29333333333333339],"automargin":true,"title":"Nitrate ratio","rangemode":"nonnegative","anchor":"x2"},"yaxis5":{"domain":[0,0.29333333333333339],"automargin":true,"title":"Florida TSI","rangemode":"nonnegative","anchor":"x"},"yaxis4":{"domain":[0.37333333333333335,0.62666666666666671],"automargin":true,"title":"DO (mg/L)","rangemode":"nonnegative","anchor":"x2"},"yaxis3":{"domain":[0.37333333333333335,0.62666666666666671],"automargin":true,"title":"Chla:TN","rangemode":"nonnegative","anchor":"x"},"yaxis2":{"domain":[0.70666666666666678,1],"automargin":true,"title":"TN (mg/L)","rangemode":"nonnegative","anchor":"x2"},"yaxis":{"domain":[0.70666666666666678,1],"automargin":true,"title":"Chla (ug/L)","rangemode":"nonnegative","anchor":"x"},"annotations":[{"x":0,"y":11,"text":"","xref":"x","yref":"y","showarrow":false,"yanchor":"top","font":{"color":"red","size":14}},{"x":0,"y":1.1000000000000001,"text":"","xref":"x2","yref":"y2","showarrow":false,"yanchor":"top","font":{"color":"red","size":14}},{"x":0,"y":15,"text":"","xref":"x","yref":"y3","showarrow":false,"yanchor":"top","font":{"color":"red","size":14}},{"x":0,"y":2,"text":"","xref":"x2","yref":"y4","showarrow":false,"yanchor":"top","font":{"color":"red","size":14}},{"x":0,"y":50,"text":"estuary","xref":"x","yref":"y5","showarrow":false,"yanchor":"top","font":{"color":"red","size":14}},{"x":0,"y":60,"text":"lake","xref":"x","yref":"y5","showarrow":false,"yanchor":"top","font":{"color":"red","size":14}},{"x":0,"y":1,"text":"","xref":"x2","yref":"y6","showarrow":false,"yanchor":"top","font":{"color":"red","size":14}}],"shapes":[{"type":"line","x0":0,"x1":0.46000000000000002,"xref":"paper","y0":11,"y1":11,"line":{"color":"red","dash":10},"yref":"y"},{"type":"line","x0":0.54000000000000004,"x1":1,"xref":"paper","y0":1.1000000000000001,"y1":1.1000000000000001,"line":{"color":"red","dash":10},"yref":"y2"},{"type":"line","x0":0,"x1":0.46000000000000002,"xref":"paper","y0":15,"y1":15,"line":{"color":"red","dash":10},"yref":"y3"},{"type":"line","x0":0.54000000000000004,"x1":1,"xref":"paper","y0":2,"y1":2,"line":{"color":"red","dash":10},"yref":"y4"},{"type":"line","x0":0,"x1":0.46000000000000002,"xref":"paper","y0":50,"y1":50,"line":{"color":"red","dash":10},"yref":"y5"},{"type":"line","x0":0,"x1":0.46000000000000002,"xref":"paper","y0":60,"y1":60,"line":{"color":"red","dash":10},"yref":"y5"},{"type":"line","x0":0.54000000000000004,"x1":1,"xref":"paper","y0":1,"y1":1,"line":{"color":"red","dash":10},"yref":"y6"}],"images":[],"margin":{"b":40,"l":60,"t":25,"r":10},"showlegend":false,"hovermode":"closest"},"attrs":{"2130320637c8":{"x":{},"y":{},"text":{},"textposition":"auto","marker":{"color":{}},"hoverinfo":"x","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"bar"},"2130371e1280":{"x":{},"y":{},"text":{},"textposition":"auto","marker":{"color":{}},"hoverinfo":"x","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"bar"},"21303a70470a":{"x":{},"y":{},"text":{},"textposition":"auto","marker":{"color":{}},"hoverinfo":"x","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"bar"},"213078845432":{"x":{},"y":{},"text":{},"textposition":"auto","marker":{"color":{}},"hoverinfo":"x","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"bar"},"2130585fc11d":{"x":{},"y":{},"text":{},"textposition":"auto","marker":{"color":{}},"hoverinfo":"x","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"bar"},"2130511a8b47":{"x":{},"y":{},"text":{},"textposition":"auto","marker":{"color":{}},"hoverinfo":"x","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"bar"}},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false,"toImageButtonOptions":{"format":"svg","filename":"myplot"}},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"subplot":true,"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
