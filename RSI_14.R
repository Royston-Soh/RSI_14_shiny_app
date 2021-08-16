library(shiny)
library(BatchGetSymbols)
library(xts)
library(quantmod)

#get_data function

get_data=function(x){
  df=BatchGetSymbols(tickers = x,
                  first.date = Sys.Date()-180,
                  last.date = Sys.Date(),
                  freq.data = 'daily')
  
  closing_price= df$df.tickers$price.adjusted
  date=df$df.tickers$ref.date
  
  df2=data.frame(closing_price)
  row.names(df2)=date
  
  df2=as.xts(df2)
  
}


ui <- fluidPage(
  selectInput('Index',label = 'Index',choices = c('S&P 500'='^GSPC','Dow'='DJI')),
  plotOutput('plot')
)

server <- function(input, output, session) {
  data_collected=reactive(get_data(input$Index))
  
  output$plot=renderPlot(
    chartSeries(data_collected(),
                theme=chartTheme('white'),
                TA=c(addRSI(n=14)))
  )
  
}

shinyApp(ui, server)





