library(shiny)
library(rCharts)

shinyUI(fluidPage(
    div(class = "hero-unit",
        style = "background-image: url(img/money-background-lrg.jpg);
        background-size: 100%;",
        h1("Stock Forecast")
    ),
    h2("User Guide"),
    div(class = "alert alert-info",
        p("This application will take user's input on a stock trading symbol and date range and
          then display the daily closing price information from Yahoo finance website on 
          interactive NVD3 line chart."),
        p("User inputs:"),
        tags$ol(
            tags$li("Stock symbol, e.g. GOOG (Google), AAPL (Apple), and GS (Goldman Sachs)"),
            tags$li("Date range")
        ),
        p('After clicking the "Generate Chart" button, the chart on the right will be updated.'),
        p("Chart outputs:"),
        tags$ol(
            tags$li("Closing Price information from Yahoo Finance"),
            tags$li("ForecastLowB: Lower Bound of 95% confidence interval from BATS forecast"),
            tags$li("ForecastHighB: Upper Bound of 95% confidence interval from BATS forecast")
        ),
        p("Note: BATS model (Exponential smoothing state space model with Box-Cox
          transformation, ARMA errors, Trend and Seasonal components)"),
        p("Note: Please don't consider this as a financial advice :)"),
        p("Note: The NVD3 chart has nice features like selectable legend, focus at the top chart and context zooming at the bottom.")        
    ),
    
    fluidRow(
        column(2,
               wellPanel(
                   textInput("symb", "Symbol", "GS"),
                   dateRangeInput("dates", 
                                  "Date range",
                                  start = "2014-01-01", 
                                  end = as.character(Sys.Date())),
                   submitButton("Generate Chart")
               )
        ),
        column(10,
               showOutput("chart1", "nvd3")
        )
    ),
    br(),
    br(),
    hr(),
    wellPanel(
        tags$ul(
            tags$li(
                tags$small("The source codes (ui.R/server.R) for this Shiny app are maintained in this ",
                           a(href="https://github.com/mike-chu/stockForecast/", "GitHub repository"))
            ),
            tags$li(
                tags$small("Banner image is reused under Createive Commons 3.0 license and created by",
                           a(href="http://freewebpageheaders.com/", "freewebpageheaders.com"))
            )
        )
    )
))
