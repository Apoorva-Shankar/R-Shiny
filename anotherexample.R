
library(shiny)
library(shinydashboard)
library(shinyjs)

header <- dashboardHeader()
sidebar <- dashboardSidebar()

body <- dashboardBody(
  useShinyjs(),
  fluidRow(
    div(id = "TimingBox",
        tabBox(id = "Timing",
               tabPanel("Tab 1", 
                        sidebarLayout(
                          div(id = "Sidebar",
                              style = "z-index: 1000;position: fixed;",
                              sidebarPanel("There are currently 20 overdue     here", width = 6)
                          ),
                          
                          mainPanel(plotOutput("plot1"), width = 12)
                        )
               ),
               tabPanel("Tab 2"),
               title = p("Status",actionLink("Link", NULL, icon = icon("plus-square-o")),actionLink("Link2", NULL, icon = icon("search"))), width = 4,
               selected = "Tab 1"
        )   
    )
  )
)

ui <- dashboardPage(header, sidebar, body)

server <- function(input, output) {
  
  shinyjs::hide(id = "Sidebar")
  
  observeEvent(input$Link, {
    shinyjs::toggle(id = "Sidebar")
  })
  
  
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(50)]
    hist(data)
  })
  
  
  
}

shinyApp(ui, server)