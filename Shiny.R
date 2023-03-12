library(rsconnect)
library(shiny)
library(tidyverse)

Uah <- read.csv("UAH-lower-troposphere-long.csv", header = TRUE, sep = "\t")
  
ui <- fluidPage(
  
  navbarPage(title = em("Different pages"),
    tabPanel(strong("Intro"),

    h3("Weather Change"),
    p("The value of this site is to show the trends that we see in the data."),
    ),
  tabPanel(strong("Year"),
  sidebarLayout(
    sidebarPanel(
      fluidRow(
        column(12,
        h3("Over the Years"),
        p("In this graph you can see the differences over the years"),
        ),
        column(5,
               dateRangeInput("daterange", label = h5("Select Date Range"),
                              start = "1978-01-01",
                              end = "2023-01-01",
                              min = "1978-01-01",
                              max = "2023-01-01",
                              startview = "decade"),

               p("Choose a date"),
               p(em("yy-mm-dd"))
        ),
        column(5,
          uiOutput("difftemp"),
          p("Choose a color")
          )     
        )
      ),
      mainPanel(plotOutput("Scatterplot")
      )
    )
  ),
 tabPanel(strong("Region"),
          sidebarLayout(
            sidebarPanel(
              fluidRow(
                column(12,
                       h3("Which region?"),
                       p("With this we can see which region is higher and lower in temperature"),
                       ), 
                column(5,
                       uiOutput("region")
                       ),
                column(5,
                       p("Pick a region")
                       ),
              )
            ),
          mainPanel(plotOutput("Region")
          )
          )
 ),
)
)
server <- function(input, output) {
  head(Uah, 10)
}

shinyApp(ui = ui, server = server)
