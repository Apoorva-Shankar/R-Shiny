### RUN ### 
# OSUICode::run_example( 
#  "input-system/bind-unbind", 
#   package = "OSUICode" 
# ) 

### APP CODE ### 
library(shiny)

ui <- fluidPage(
  actionButton(
    "unbind",
    "Unbind inputs",
    onclick = "Shiny.unbindAll();"
  ),
  actionButton(
    "bind",
    "Bind inputs",
    onclick = "Shiny.bindAll();"
  ),
  lapply(1:3, function(i) {
    textInput(paste0("text_", i), paste("Text", i))
  }),
  lapply(1:3, function(i) {
    uiOutput(paste0("val_", i))
  })
)

server <- function(input, output, session) {
  lapply(1:3, function(i) {
    output[[paste0("val_", i)]] <- renderPrint({
      input[[paste0("text_", i)]]
    })
  })
}

shinyApp(ui, server)

#----------------------------

library(shiny)

ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "minty"),
  titlePanel("Old Faithful Geyser Data"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    mainPanel(plotOutput("distPlot"))
  )
)

server <- function(input, output) {
  output$distPlot <- renderPlot({
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
}

shinyApp(ui = ui, server = server)

#-------------------------------------------------------------------------------
library(shiny)
library(kableExtra)
install.packages("kableExtra")

ui = shiny::fluidPage(
  tags$style(HTML("div.sticky {
  position: -webkit-sticky;
  position: sticky;
  top: 0;
  z-index: 1;
}")),
  shiny::sidebarLayout(
    tagAppendAttributes(shiny::sidebarPanel(
      shiny::sliderInput("n", "n", min = 20, max = 100, value = 20, step = 5),
    ), class = "sticky"),
    shiny::mainPanel(
      shiny::tableOutput("show")
    )
  )
)
server = function(input, output, session) {
  output$show = function() {
    df = data.frame(i  = 1:input$n)
    kableExtra::kbl(df)
  }
}
shiny::shinyApp(ui = ui, server = server)