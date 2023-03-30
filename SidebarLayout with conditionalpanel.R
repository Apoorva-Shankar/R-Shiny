    ui <- fluidPage(
      
      titlePanel("Trial"),
      div(
        style = "margin-top:1%;position:sticky;",
        actionButton("toggleSidebarPanel",
                     "Filter",
                     icon = icon("bars"), )
        
      ),
      
      sidebarLayout(
        conditionalPanel(
          condition = "input.toggleSidebarPanel % 2 == 0",
          sidebarPanel(
            sliderInput(
              "bins", label = "Number of bins:",
              min = 1, value = 30, max = 50
            )
          )
        )
        
,
        
        mainPanel(
          fluidRow(
            column(12,
                   dataTableOutput('table')
            )
          )
        )
      )
    )
    server = function(input, output) {
      output$table <- renderDataTable(iris)
    }
    shinyApp(ui, server)