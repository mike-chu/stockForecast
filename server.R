library(shiny)
library(quantmod)
library(rCharts)
library(forecast)
library(reshape2)

shinyServer(function(input, output) {
    data <- reactive({
        data.xts <- getSymbols(input$symb, src = "yahoo", 
                               from = input$dates[1],
                               to = input$dates[2],
                               auto.assign = FALSE)
        data.df <- data.frame(index(data.xts), coredata(data.xts), stringsAsFactors=FALSE)
        data.df <- data.df[,c(1, 5)]
        colnames(data.df) <- c("Date", "ClosingPrice")
        fit <- bats(data.df$ClosingPrice, use.parallel=FALSE)
        fcast <- forecast(fit, h=3, level=95)
        data.df$ForecastLowB <- rep(NA, nrow(data.df))
        data.df$ForecastHighB <- rep(NA, nrow(data.df))
        pred <- data.frame(Date=max(data.df$Date)+1:3,
                           ClosingPrice=rep(NA,3),
                           ForecastLowB=round(fcast$lower,2),
                           ForecastHighB=round(fcast$upper,2))
        data.df <- rbind(data.df, pred)
        data.melt <- melt(data.df, id.vars=1)
        data.melt        
    })
    
    output$chart1 <- renderChart({
        df <- data()
        n1 <- nPlot(value ~ Date, group = 'variable',
                    data = df,
                    type = 'lineWithFocusChart'
        )
        n1$chart(
            color = c('blue', 'green', 'red'),
            margin = list(left = 100)
        )
        n1$set(
            dom = 'chart1'
        )
        n1$xAxis(
            axisLabel = "Date",
            tickFormat = "#!function(d) {return d3.time.format('%d-%b-%Y')(new Date( d * 86400000 ));}!#"
        )
        n1$x2Axis(
            tickFormat = "#!function(d) {return d3.time.format('%b-%Y')(new Date( d * 86400000 ));}!#"
        )
        n1$yAxis(
            axisLabel = "Stock Price",
            tickFormat = "#! function(d) {return '$' + d3.format(',.2f')(d)} !#"
        )
        return(n1)
    })
})
