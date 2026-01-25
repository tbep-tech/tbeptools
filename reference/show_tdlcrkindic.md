# Plotly barplots of tidal creek context indicators

Plotly barplots of tidal creek context indicators

## Usage

``` r
show_tdlcrkindic(
  id,
  cntdat,
  yr = 2024,
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
cntdat <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2024)

set.seed(123)
id <- sample(unique(cntdat$id), 1)
show_tdlcrkindic(id, cntdat, thrsel = TRUE)

{"x":{"data":[{"x":["2015","2016","2017","2018","2019","2020","2021","2022","2023","2024"],"y":[7.8685364162138098,3.6106812937218402,2.8881932356336302,2.6280454494246901,2.0211589145287698,2.4731102640559302,2.9617136825596799,1.8359432386219099,2.6050458888741899,0.90000000000000002],"text":[7.9000000000000004,3.6000000000000001,2.8999999999999999,2.6000000000000001,2,2.5,3,1.8,2.6000000000000001,0.90000000000000002],"textposition":["auto","auto","auto","auto","auto","auto","auto","auto","auto","auto"],"marker":{"color":["#5C4A42","#585346","#545D4A","#4E664F","#476F53","#3F6F5A","#396763","#2F5F6C","#215775","#004F7E"],"line":{"color":"rgba(31,119,180,1)"}},"hoverinfo":["x","x","x","x","x","x","x","x","x","x"],"type":"bar","error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":["2015","2016","2017","2018","2019","2020","2021","2022","2023","2024"],"y":[1.20254596602524,0.89733635721437599,0.83905404636502701,0.83974373341098396,0.81035989347221404,0.91053481386769897,0.93909671470273903,0.88066202357696,0.786631092518423,0.625],"text":[1.2,0.90000000000000002,0.80000000000000004,0.80000000000000004,0.80000000000000004,0.90000000000000002,0.90000000000000002,0.90000000000000002,0.80000000000000004,0.59999999999999998],"textposition":["auto","auto","auto","auto","auto","auto","auto","auto","auto","auto"],"marker":{"color":["#5C4A42","#585346","#545D4A","#4E664F","#476F53","#3F6F5A","#396763","#2F5F6C","#215775","#004F7E"],"line":{"color":"rgba(255,127,14,1)"}},"hoverinfo":["x","x","x","x","x","x","x","x","x","x"],"type":"bar","error_y":{"color":"rgba(255,127,14,1)"},"error_x":{"color":"rgba(255,127,14,1)"},"xaxis":"x2","yaxis":"y2","frame":null},{"x":["2015","2016","2017","2018","2019","2020","2021","2022","2023","2024"],"y":[6.5432313096700803,4.0237768866632901,3.4422016652514098,3.1295803051125399,2.49414973619752,2.7161073101102402,3.1537898452739999,2.0847307928243701,3.3116487685912102,1.4399999999999999],"text":[6.5,4,3.3999999999999999,3.1000000000000001,2.5,2.7000000000000002,3.2000000000000002,2.1000000000000001,3.2999999999999998,1.3999999999999999],"textposition":["auto","auto","auto","auto","auto","auto","auto","auto","auto","auto"],"marker":{"color":["#5C4A42","#585346","#545D4A","#4E664F","#476F53","#3F6F5A","#396763","#2F5F6C","#215775","#004F7E"],"line":{"color":"rgba(44,160,44,1)"}},"hoverinfo":["x","x","x","x","x","x","x","x","x","x"],"type":"bar","error_y":{"color":"rgba(44,160,44,1)"},"error_x":{"color":"rgba(44,160,44,1)"},"xaxis":"x","yaxis":"y3","frame":null},{"x":["2015","2016","2017","2018","2019","2020","2021","2022","2023","2024"],"y":[6.5780520395555104,4.9213763625097302,5.6776776457620102,0,8.6833296981218506,6.3903104716392001,6.3992226191484498,7.3135618046442898,10.6818622306275,13.130000000000001],"text":[6.5999999999999996,4.9000000000000004,5.7000000000000002,0,8.6999999999999993,6.4000000000000004,6.4000000000000004,7.2999999999999998,10.699999999999999,13.1],"textposition":["auto","auto","auto","auto","auto","auto","auto","auto","auto","auto"],"marker":{"color":["#5C4A42","#585346","#545D4A","#4E664F","#476F53","#3F6F5A","#396763","#2F5F6C","#215775","#004F7E"],"line":{"color":"rgba(214,39,40,1)"}},"hoverinfo":["x","x","x","x","x","x","x","x","x","x"],"type":"bar","error_y":{"color":"rgba(214,39,40,1)"},"error_x":{"color":"rgba(214,39,40,1)"},"xaxis":"x2","yaxis":"y4","frame":null},{"x":["2015","2016","2017","2018","2019","2020","2021","2022","2023","2024"],"y":[54.7102222548463,45.507301657197999,43.951413566907199,43.927403438184299,40.348176858655599,43.6263388966387,44.9944237896026,41.551612141376999,43.411177100528299,30.530454147226301],"text":[54.700000000000003,45.5,44,43.899999999999999,40.299999999999997,43.600000000000001,45,41.600000000000001,43.399999999999999,30.5],"textposition":["auto","auto","auto","auto","auto","auto","auto","auto","auto","auto"],"marker":{"color":["#5C4A42","#585346","#545D4A","#4E664F","#476F53","#3F6F5A","#396763","#2F5F6C","#215775","#004F7E"],"line":{"color":"rgba(148,103,189,1)"}},"hoverinfo":["x","x","x","x","x","x","x","x","x","x"],"type":"bar","error_y":{"color":"rgba(148,103,189,1)"},"error_x":{"color":"rgba(148,103,189,1)"},"xaxis":"x","yaxis":"y5","frame":null},{"x":["2015","2016","2017","2018","2019","2020","2021","2022","2023","2024"],"y":[0,0,0,0.3125,0,0,0.64864864864864902,0,0,0],"text":[0,0,0,0.29999999999999999,0,0,0.59999999999999998,0,0,0],"textposition":["auto","auto","auto","auto","auto","auto","auto","auto","auto","auto"],"marker":{"color":["#5C4A42","#585346","#545D4A","#4E664F","#476F53","#3F6F5A","#396763","#2F5F6C","#215775","#004F7E"],"line":{"color":"rgba(140,86,75,1)"}},"hoverinfo":["x","x","x","x","x","x","x","x","x","x"],"type":"bar","error_y":{"color":"rgba(140,86,75,1)"},"error_x":{"color":"rgba(140,86,75,1)"},"xaxis":"x2","yaxis":"y6","frame":null}],"layout":{"xaxis":{"domain":[0,0.46000000000000002],"automargin":true,"title":"","type":"category","categoryorder":"array","categoryarray":["2015","2016","2017","2018","2019","2020","2021","2022","2023","2024"],"anchor":"y5"},"xaxis2":{"domain":[0.54000000000000004,1],"automargin":true,"title":"","type":"category","categoryorder":"array","categoryarray":["2015","2016","2017","2018","2019","2020","2021","2022","2023","2024"],"anchor":"y6"},"yaxis6":{"domain":[0,0.29333333333333339],"automargin":true,"title":"Nitrate ratio","rangemode":"nonnegative","anchor":"x2"},"yaxis5":{"domain":[0,0.29333333333333339],"automargin":true,"title":"Florida TSI","rangemode":"nonnegative","anchor":"x"},"yaxis4":{"domain":[0.37333333333333335,0.62666666666666671],"automargin":true,"title":"DO (mg/L)","rangemode":"nonnegative","anchor":"x2"},"yaxis3":{"domain":[0.37333333333333335,0.62666666666666671],"automargin":true,"title":"Chla:TN","rangemode":"nonnegative","anchor":"x"},"yaxis2":{"domain":[0.70666666666666678,1],"automargin":true,"title":"TN (mg/L)","rangemode":"nonnegative","anchor":"x2"},"yaxis":{"domain":[0.70666666666666678,1],"automargin":true,"title":"Chla (ug/L)","rangemode":"nonnegative","anchor":"x"},"annotations":[{"x":0,"y":11,"text":"","xref":"x","yref":"y","showarrow":false,"yanchor":"top","font":{"color":"red","size":14}},{"x":0,"y":1.1000000000000001,"text":"","xref":"x2","yref":"y2","showarrow":false,"yanchor":"top","font":{"color":"red","size":14}},{"x":0,"y":15,"text":"","xref":"x","yref":"y3","showarrow":false,"yanchor":"top","font":{"color":"red","size":14}},{"x":0,"y":2,"text":"","xref":"x2","yref":"y4","showarrow":false,"yanchor":"top","font":{"color":"red","size":14}},{"x":0,"y":50,"text":"estuary","xref":"x","yref":"y5","showarrow":false,"yanchor":"top","font":{"color":"red","size":14}},{"x":0,"y":60,"text":"lake","xref":"x","yref":"y5","showarrow":false,"yanchor":"top","font":{"color":"red","size":14}},{"x":0,"y":1,"text":"","xref":"x2","yref":"y6","showarrow":false,"yanchor":"top","font":{"color":"red","size":14}}],"shapes":[{"type":"line","x0":0,"x1":0.46000000000000002,"xref":"paper","y0":11,"y1":11,"line":{"color":"red","dash":10},"yref":"y"},{"type":"line","x0":0.54000000000000004,"x1":1,"xref":"paper","y0":1.1000000000000001,"y1":1.1000000000000001,"line":{"color":"red","dash":10},"yref":"y2"},{"type":"line","x0":0,"x1":0.46000000000000002,"xref":"paper","y0":15,"y1":15,"line":{"color":"red","dash":10},"yref":"y3"},{"type":"line","x0":0.54000000000000004,"x1":1,"xref":"paper","y0":2,"y1":2,"line":{"color":"red","dash":10},"yref":"y4"},{"type":"line","x0":0,"x1":0.46000000000000002,"xref":"paper","y0":50,"y1":50,"line":{"color":"red","dash":10},"yref":"y5"},{"type":"line","x0":0,"x1":0.46000000000000002,"xref":"paper","y0":60,"y1":60,"line":{"color":"red","dash":10},"yref":"y5"},{"type":"line","x0":0.54000000000000004,"x1":1,"xref":"paper","y0":1,"y1":1,"line":{"color":"red","dash":10},"yref":"y6"}],"images":[],"margin":{"b":40,"l":60,"t":25,"r":10},"showlegend":false,"hovermode":"closest"},"attrs":{"2070479b002b":{"x":{},"y":{},"text":{},"textposition":"auto","marker":{"color":{}},"hoverinfo":"x","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"bar"},"20702d9a1718":{"x":{},"y":{},"text":{},"textposition":"auto","marker":{"color":{}},"hoverinfo":"x","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"bar"},"2070102e2236":{"x":{},"y":{},"text":{},"textposition":"auto","marker":{"color":{}},"hoverinfo":"x","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"bar"},"2070484612c6":{"x":{},"y":{},"text":{},"textposition":"auto","marker":{"color":{}},"hoverinfo":"x","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"bar"},"207041d5942c":{"x":{},"y":{},"text":{},"textposition":"auto","marker":{"color":{}},"hoverinfo":"x","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"bar"},"2070b1ee688":{"x":{},"y":{},"text":{},"textposition":"auto","marker":{"color":{}},"hoverinfo":"x","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"bar"}},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false,"toImageButtonOptions":{"format":"svg","filename":"myplot"}},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"subplot":true,"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
