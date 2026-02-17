# Show a Split Bar Plot with Error Bars

This function creates a bar plot with error bars based on two groups
split by a year value. It can optionally create an interactive plot and
show individual data points.

## Usage

``` r
show_splitbarplot(
  df,
  period_col,
  year_col,
  value_col,
  x_label_prefix = "",
  interactive = TRUE,
  source = "A",
  exploded = FALSE,
  bars_fill = c("#00BFC4", "#F8766D"),
  bars_alpha = 0.7,
  label_points = c("min", "max", "median"),
  label_color = "black",
  value_round = 2,
  text_size = 14
)
```

## Arguments

- df:

  A data frame containing the data to plot

- period_col:

  Name of the column containing values "before" and "after" as an
  ordered factor

- year_col:

  Name of the column containing year values

- value_col:

  Name of the column containing the values to plot

- x_label_prefix:

  Optional prefix for x-axis labels (default: "")

- interactive:

  Logical; if TRUE, creates an interactive plot using plotly (default:
  TRUE)

- source:

  if interactive is TRUE, the `source` argument to
  [`plotly::ggplotly`](https://rdrr.io/pkg/plotly/man/ggplotly.html) for
  referencing with click events (default: "A")

- exploded:

  Logical; if TRUE, adds individual points with labels for min, max, and
  mean (default: FALSE)

- bars_fill:

  Fill color for bars (default: `c("#00BFC4", "#F8766D")`; teal and red)

- bars_alpha:

  Alpha transparency for bars (default: 0.7)

- label_points:

  Character vector specifying which points to label in exploded view
  (default: c("min","max","median"))

- label_color:

  Color for labeled points in exploded view (default: "black")

- value_round:

  Integer indicating number of decimal places for rounding values
  (default: 2)

- text_size:

  Size of text for labels and hover text (default: 14)

## Value

A ggplot2 object or plotly object (if interactive = TRUE)

## Examples

``` r
# Create example data
data <- data.frame(
  date = seq.Date(as.Date("2010-01-01"), as.Date("2020-12-31"), by = "month"),
  value = c(rnorm(66, mean = 10, sd = 4), rnorm(66, mean = 20, sd = 4))
  )

# Basic analysis with default statistics
split_date <- as.Date("2015-06-15")
df <- anlz_splitdata(data, split_date, "date", "value")

# Basic interactive plot
show_splitbarplot(df, "period", "year", "avg")

{"x":{"data":[{"orientation":"v","width":0.89999999999999991,"base":0,"x":[1],"y":[10.134430713450085],"text":"","type":"bar","textposition":"none","marker":{"autocolorscale":false,"color":"rgba(0,191,196,0.7)","line":{"width":1.8897637795275593,"color":"transparent"}},"name":"2010-15","legendgroup":"2010-15","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"orientation":"v","width":0.90000000000000013,"base":0,"x":[2],"y":[21.191618290965501],"text":"","type":"bar","textposition":"none","marker":{"autocolorscale":false,"color":"rgba(248,118,109,0.7)","line":{"width":1.8897637795275593,"color":"transparent"}},"name":"2016-21","legendgroup":"2016-21","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[1],"y":[10.134430713450085],"text":"","type":"scatter","mode":"lines","opacity":1,"line":{"color":"transparent"},"error_y":{"array":[1.0519725944654308],"arrayminus":[1.0519725944654308],"type":"data","width":14.545454545454559,"symmetric":false,"color":"rgba(169,169,169,1)"},"name":"2010-15","legendgroup":"2010-15","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[2],"y":[21.191618290965501],"text":"","type":"scatter","mode":"lines","opacity":1,"line":{"color":"transparent"},"error_y":{"array":[1.1058708050471644],"arrayminus":[1.1058708050471644],"type":"data","width":14.545454545454559,"symmetric":false,"color":"rgba(169,169,169,1)"},"name":"2016-21","legendgroup":"2016-21","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":23.305936073059364,"r":7.3059360730593621,"b":29.555832295558321,"l":29.555832295558321},"plot_bgcolor":"rgba(235,235,235,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.611872146118724},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[0.40000000000000002,2.6000000000000001],"tickmode":"array","ticktext":["2010-15","2016-21"],"tickvals":[1,2],"categoryorder":"array","categoryarray":["2010-15","2016-21"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.6529680365296811,"tickwidth":0.66417600664176002,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":18.596928185969279},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"y","title":{"text":"","font":{"color":null,"family":null,"size":0}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[7.7183751175379109,24.242564756400409],"tickmode":"array","ticktext":["8","12","16","20","24"],"tickvals":[8,12,16,20,24],"categoryorder":"array","categoryarray":["8","12","16","20","24"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.6529680365296811,"tickwidth":0.66417600664176002,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":18.596928185969279},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"x","title":{"text":"","font":{"color":null,"family":null,"size":0}},"hoverformat":".2f"},"shapes":[],"showlegend":false,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.8897637795275593,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.68949771689498}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"source":"A","attrs":{"1e9f6b2669ba":{"x":{},"y":{},"fill":{},"type":"bar"},"1e9f1cfa55eb":{"x":{},"y":{},"fill":{},"ymin":{},"ymax":{}}},"cur_data":"1e9f6b2669ba","visdat":{"1e9f6b2669ba":["function (y) ","x"],"1e9f1cfa55eb":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
# Custom colors and labels with 1 decimal place
show_splitbarplot(df, "period", "year", "avg",
            bars_fill = c("steelblue", "darkorange"),
            exploded = TRUE,
            label_points = c("min", "max"),
            label_color = "darkred",
            value_round = 1)

{"x":{"data":[{"orientation":"v","width":0.89999999999999991,"base":0,"x":[1],"y":[10.134430713450085],"text":"","type":"bar","textposition":"none","marker":{"autocolorscale":false,"color":"rgba(70,130,180,0.7)","line":{"width":1.8897637795275593,"color":"transparent"}},"name":"2010-15","legendgroup":"2010-15","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"orientation":"v","width":0.90000000000000013,"base":0,"x":[2],"y":[21.191618290965501],"text":"","type":"bar","textposition":"none","marker":{"autocolorscale":false,"color":"rgba(255,140,0,0.7)","line":{"width":1.8897637795275593,"color":"transparent"}},"name":"2016-21","legendgroup":"2016-21","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[1],"y":[10.134430713450085],"text":"","type":"scatter","mode":"lines","opacity":1,"line":{"color":"transparent"},"error_y":{"array":[1.0519725944654308],"arrayminus":[1.0519725944654308],"type":"data","width":14.545454545454559,"symmetric":false,"color":"rgba(169,169,169,1)"},"name":"2010-15","legendgroup":"2010-15","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[2],"y":[21.191618290965501],"text":"","type":"scatter","mode":"lines","opacity":1,"line":{"color":"transparent"},"error_y":{"array":[1.1058708050471644],"arrayminus":[1.1058708050471644],"type":"data","width":14.545454545454559,"symmetric":false,"color":"rgba(169,169,169,1)"},"name":"2016-21","legendgroup":"2016-21","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[1.0992391427978874,0.87451638877391813,1.1349446639418601,0.8576346480287611,1.1254542236216367,0.93021120615303521],"y":[9.1522924002491202,10.6107331614391,9.2802313559782394,9.2724953610912504,11.692968398565901,10.7978636033769],"text":["2010: 9.2","2011: 10.6","2012: 9.3","2013: 9.3","2014: 11.7","2015: 10.8"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(70,130,180,1)","opacity":0.5,"size":5.6692913385826778,"symbol":"circle","line":{"width":1.8897637795275593,"color":"rgba(0,0,0,1)"}},"hoveron":"points","name":"2010-15","legendgroup":"2010-15","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[1.9723829592578113,2.1848504869267344,2.0538193345069886,1.9690639060921966,1.8859060984104872,1.9762350698933004],"y":[20.604352834818599,20.594808609220902,21.713339543548301,19.6966830375667,21.7318782469493,22.808647473689199],"text":["2016: 20.6","2017: 20.6","2018: 21.7","2019: 19.7","2020: 21.7","2021: 22.8"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(255,140,0,1)","opacity":0.5,"size":5.6692913385826778,"symbol":"circle","line":{"width":1.8897637795275593,"color":"rgba(0,0,0,1)"}},"hoveron":"points","name":"2016-21","legendgroup":"2016-21","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[1.0992391427978874,1.1254542236216367],"y":[9.1522924002491202,11.692968398565901],"text":"","type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(70,130,180,1)","opacity":1,"size":7.559055118110237,"symbol":"circle","line":{"width":1.8897637795275593,"color":"rgba(0,0,0,1)"}},"hoveron":"points","name":"2010-15","legendgroup":"2010-15","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[1.9690639060921966,1.9762350698933004],"y":[19.6966830375667,22.808647473689199],"text":"","type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(255,140,0,1)","opacity":1,"size":7.559055118110237,"symbol":"circle","line":{"width":1.8897637795275593,"color":"rgba(0,0,0,1)"}},"hoveron":"points","name":"2016-21","legendgroup":"2016-21","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[1.0992391427978874,1.1254542236216367],"y":[8.9022924002491202,11.442968398565901],"text":["2010: 9.2","2014: 11.7"],"hovertext":["",""],"textfont":{"size":14.611872146118722,"color":"rgba(0,0,0,1)"},"type":"scatter","mode":"text","hoveron":"points","name":"2010-15","legendgroup":"2010-15","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[1.9690639060921966,1.9762350698933004],"y":[19.4466830375667,22.558647473689199],"text":["2019: 19.7","2021: 22.8"],"hovertext":["",""],"textfont":{"size":14.611872146118722,"color":"rgba(0,0,0,1)"},"type":"scatter","mode":"text","hoveron":"points","name":"2016-21","legendgroup":"2016-21","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":23.305936073059364,"r":7.3059360730593621,"b":29.555832295558321,"l":29.555832295558321},"plot_bgcolor":"rgba(235,235,235,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.611872146118724},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[0.40000000000000002,2.6000000000000001],"tickmode":"array","ticktext":["2010-15","2016-21"],"tickvals":[1,2],"categoryorder":"array","categoryarray":["2010-15","2016-21"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.6529680365296811,"tickwidth":0.66417600664176002,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":18.596928185969279},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"y","title":{"text":"","font":{"color":null,"family":null,"size":0}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[7.7183751175379109,24.242564756400409],"tickmode":"array","ticktext":["8","12","16","20","24"],"tickvals":[8,12,16,20,24],"categoryorder":"array","categoryarray":["8","12","16","20","24"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.6529680365296811,"tickwidth":0.66417600664176002,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":18.596928185969279},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"x","title":{"text":"","font":{"color":null,"family":null,"size":0}},"hoverformat":".2f"},"shapes":[],"showlegend":false,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.8897637795275593,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.68949771689498}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"source":"A","attrs":{"1e9f38be9507":{"x":{},"y":{},"fill":{},"type":"bar"},"1e9f322c53c0":{"x":{},"y":{},"fill":{},"ymin":{},"ymax":{}},"1e9f7acbf9c3":{"x":{},"y":{},"fill":{},"text":{}},"1e9f3e5617d":{"x":{},"y":{},"fill":{}},"1e9f747df48c":{"x":{},"y":{},"fill":{},"label":{}}},"cur_data":"1e9f38be9507","visdat":{"1e9f38be9507":["function (y) ","x"],"1e9f322c53c0":["function (y) ","x"],"1e9f7acbf9c3":["function (y) ","x"],"1e9f3e5617d":["function (y) ","x"],"1e9f747df48c":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
