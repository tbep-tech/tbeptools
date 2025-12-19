# Plot frequency occurrence for a seagrass transect by time for all species

Plot frequency occurrence for a seagrass transect by time for all
species

## Usage

``` r
show_transectsum(
  transectocc,
  site,
  species = c("Halodule", "Syringodium", "Thalassia", "Halophila", "Ruppia", "Caulerpa",
    "Dapis", "Chaetomorpha"),
  yrrng = c(1998, 2025),
  abund = FALSE,
  sppcol = NULL
)
```

## Arguments

- transectocc:

  data frame returned by
  [`anlz_transectocc`](https://tbep-tech.github.io/tbeptools/reference/anlz_transectocc.md)

- site:

  chr string indicating site results to plot

- species:

  chr string indicating which species to plot

- yrrng:

  numeric indicating year ranges to evaluate

- abund:

  logical indicating if abundance averages are plotted instead of
  frequency occurrence

- sppcol:

  character vector of alternative colors to use for each species, must
  have length of six

## Value

A [`plotly`](https://rdrr.io/pkg/plotly/man/plotly.html) object

## Details

This plot provides a quick visual assessment of how frequency occurrence
or abundance for multiple species has changed over time at a selected
transect. Drift or attached macroalgae (e.g., Caulerpa, Chaetomorpha)
and cyanobacteria (Dapis) estimates may not be accurate prior to 2021.

## Examples

``` r
if (FALSE) { # \dontrun{
transect <- read_transect()
} # }
transectocc <- anlz_transectocc(transect)
show_transectsum(transectocc, site = 'S3T10')

{"x":{"visdat":{"1fa269745bb5":["function () ","plotlyVisDat"]},"cur_data":"1fa269745bb5","attrs":{"1fa269745bb5":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"x":{},"y":{},"type":"scatter","mode":"markers","color":{},"colors":["#ED90A4","#CCA65A","#7EBA68","#00C1B2","#D400FF","#6FB1E7"],"stackgroup":"one","marker":{"opacity":0,"size":0},"inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"yaxis":{"domain":[0,1],"automargin":true,"title":"Frequency occurrence"},"xaxis":{"domain":[0,1],"automargin":true,"title":null,"gridcolor":"#FFFFFF","tickvals":[2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025]},"barmode":"stack","showlegend":true,"legend":{"title":{"text":"Species"}},"shapes":[{"type":"line","y0":0,"y1":0.34042553191489361,"xref":"x","x0":2000,"x1":2000,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.30434782608695654,"xref":"x","x0":2001,"x1":2001,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.36734693877551017,"xref":"x","x0":2002,"x1":2002,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.34042553191489361,"xref":"x","x0":2003,"x1":2003,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.43333333333333329,"xref":"x","x0":2004,"x1":2004,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.63380281690140838,"xref":"x","x0":2005,"x1":2005,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.40566037735849053,"xref":"x","x0":2006,"x1":2006,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.35384615384615387,"xref":"x","x0":2007,"x1":2007,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.34246575342465752,"xref":"x","x0":2008,"x1":2008,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.46428571428571425,"xref":"x","x0":2009,"x1":2009,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.84444444444444444,"xref":"x","x0":2010,"x1":2010,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.72340425531914887,"xref":"x","x0":2011,"x1":2011,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.48076923076923073,"xref":"x","x0":2012,"x1":2012,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.62745098039215685,"xref":"x","x0":2013,"x1":2013,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.66666666666666663,"xref":"x","x0":2014,"x1":2014,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.7592592592592593,"xref":"x","x0":2015,"x1":2015,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.64444444444444449,"xref":"x","x0":2016,"x1":2016,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.55813953488372092,"xref":"x","x0":2017,"x1":2017,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.68085106382978722,"xref":"x","x0":2018,"x1":2018,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":1,"xref":"x","x0":2019,"x1":2019,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.62790697674418605,"xref":"x","x0":2020,"x1":2020,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":1.0238095238095237,"xref":"x","x0":2021,"x1":2021,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.9152542372881356,"xref":"x","x0":2022,"x1":2022,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.80487804878048785,"xref":"x","x0":2023,"x1":2023,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":0.91836734693877542,"xref":"x","x0":2024,"x1":2024,"line":{"color":"grey","width":0.5,"opacity":0.5}},{"type":"line","y0":0,"y1":1.0652173913043479,"xref":"x","x0":2025,"x1":2025,"line":{"color":"grey","width":0.5,"opacity":0.5}}],"title":"S3T10","hovermode":"closest"},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false,"toImageButtonOptions":{"format":"svg","filename":"myplot"}},"data":[{"x":[2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025],"y":[0.2978723404255319,0.21739130434782608,0.24489795918367346,0.2978723404255319,0.34999999999999998,0.352112676056338,0.32075471698113206,0.23076923076923078,0.21917808219178081,0.2857142857142857,0.64444444444444449,0.44680851063829785,0.26923076923076922,0.33333333333333331,0.37777777777777777,0.42592592592592593,0.24444444444444444,0.18604651162790697,0.19148936170212766,0.40000000000000002,0.20930232558139536,0.66666666666666663,0.20338983050847459,0.1951219512195122,0.34693877551020408,0.39130434782608697],"type":"scatter","mode":"markers","stackgroup":"one","marker":{"color":"rgba(237,144,164,1)","opacity":0,"size":0,"line":{"color":"rgba(237,144,164,1)"}},"name":"Halodule","textfont":{"color":"rgba(237,144,164,1)"},"error_y":{"color":"rgba(237,144,164,1)"},"error_x":{"color":"rgba(237,144,164,1)"},"line":{"color":"rgba(237,144,164,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":[2000,2003,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025],"y":[0.042553191489361701,0.021276595744680851,0.009433962264150943,0.015384615384615385,0.013698630136986301,0.035714285714285712,0.044444444444444446,0.063829787234042548,0.057692307692307696,0.11764705882352941,0.088888888888888892,0.07407407407407407,0.17777777777777778,0.16279069767441862,0.23404255319148937,0.22,0.23255813953488372,0.21428571428571427,0.33898305084745761,0.31707317073170732,0.32653061224489793,0.41304347826086957],"type":"scatter","mode":"markers","stackgroup":"one","marker":{"color":"rgba(204,166,90,1)","opacity":0,"size":0,"line":{"color":"rgba(204,166,90,1)"}},"name":"Syringodium","textfont":{"color":"rgba(204,166,90,1)"},"error_y":{"color":"rgba(204,166,90,1)"},"error_x":{"color":"rgba(204,166,90,1)"},"line":{"color":"rgba(204,166,90,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":[2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025],"y":[0.086956521739130432,0.12244897959183673,0.021276595744680851,0.083333333333333329,0.098591549295774641,0.075471698113207544,0.092307692307692313,0.095890410958904104,0.14285714285714285,0.15555555555555556,0.21276595744680851,0.13461538461538461,0.17647058823529413,0.20000000000000001,0.25925925925925924,0.20000000000000001,0.20930232558139536,0.25531914893617019,0.34000000000000002,0.18604651162790697,0.11904761904761904,0.3728813559322034,0.29268292682926828,0.24489795918367346,0.2608695652173913],"type":"scatter","mode":"markers","stackgroup":"one","marker":{"color":"rgba(126,186,104,1)","opacity":0,"size":0,"line":{"color":"rgba(126,186,104,1)"}},"name":"Thalassia","textfont":{"color":"rgba(126,186,104,1)"},"error_y":{"color":"rgba(126,186,104,1)"},"error_x":{"color":"rgba(126,186,104,1)"},"line":{"color":"rgba(126,186,104,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":[2005,2016,2019],"y":[0.18309859154929578,0.022222222222222223,0.040000000000000001],"type":"scatter","mode":"markers","stackgroup":"one","marker":{"color":"rgba(0,193,178,1)","opacity":0,"size":0,"line":{"color":"rgba(0,193,178,1)"}},"name":"Ruppia","textfont":{"color":"rgba(0,193,178,1)"},"error_y":{"color":"rgba(0,193,178,1)"},"error_x":{"color":"rgba(0,193,178,1)"},"line":{"color":"rgba(0,193,178,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":[2007,2008],"y":[0.015384615384615385,0.013698630136986301],"type":"scatter","mode":"markers","stackgroup":"one","marker":{"color":"rgba(212,0,255,1)","opacity":0,"size":0,"line":{"color":"rgba(212,0,255,1)"}},"name":"Caulerpa","textfont":{"color":"rgba(212,0,255,1)"},"error_y":{"color":"rgba(212,0,255,1)"},"error_x":{"color":"rgba(212,0,255,1)"},"line":{"color":"rgba(212,0,255,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":[2012,2021],"y":[0.019230769230769232,0.023809523809523808],"type":"scatter","mode":"markers","stackgroup":"one","marker":{"color":"rgba(111,177,231,1)","opacity":0,"size":0,"line":{"color":"rgba(111,177,231,1)"}},"name":"Halophila","textfont":{"color":"rgba(111,177,231,1)"},"error_y":{"color":"rgba(111,177,231,1)"},"error_x":{"color":"rgba(111,177,231,1)"},"line":{"color":"rgba(111,177,231,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
