library(rsconnect)
library(shiny)
library(tidyverse)
library(lubridate)

Uah <- read.csv("UAH-lower-troposphere-long.csv", header = TRUE, sep = "\t")


ui <- fluidPage(

  navbarPage(title = em("Different pages"),
    tabPanel(strong("Intro"),
    plotOutput("main"),
    h3("Weather Change"),
    p("The value of this site is to show the trends that we see in the data about weather change in their respective regions and try to find a trend in the data."),
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
               dateRangeInput("dater", label = h5("Select Date Range"), start = "1978-01-01",
end = "2023-01-01", min = "1978-01-01", max = "2023-01-01", startview = "decade"),

p("Choose a date"),
p(em("yy-mm-dd"))
        ),

        column(5,
               radioButtons("choose","Choose a color", c("Black", "Red", "Blue")),
          uiOutput("color"),
          p(em("All different colors"))
          )     
        )
      ),
      mainPanel(plotOutput("scatterplot")
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
                       checkboxGroupInput("regin", "Some Regions", c("globe", "nh", "sh")),
                       ),
                column(5,
                       p("Pick a region")
                       ),
              )
            ),
          mainPanel(tableOutput("Region")
          )
          )
 ),
)
)
server <- function(input, output) {
  average <- ggplot(Uah, aes(x= year, y = temp)) + geom_point() + 
    labs(title = "Temperature over the years", x = "Time", y = "Temperature (F)")    
  output$main <- renderPlot({average})
  years <- reactive({ Uah %>% filter(year < input$dater[1] & year <= input$dater[2])
  })
  output$scatterplot <- renderPlot({
fal <- FALSE

plot <- ggplot(years(), aes(x= year, y = temp, color = input$color)) + geom_point() +
labs(title = "Temperature over the years", x = "Time", y = "Temperature (F)")
if(fal) {
  plot <- plot + geom_smooth(method = "1m", se = FALSE)
}
plot
})   
    output$Region <- renderTable({Uah
    })
}
shinyApp(ui = ui, server = server)
