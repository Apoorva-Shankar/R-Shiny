##Attempt 1

library(shiny)
library(ggplot2)
library(tidyverse)
library(maps)

# Load US state data and state centroids
us_states <- map_data("state")
state_centroids <- us_states %>%
  group_by(region) %>%
  summarise(lat = mean(lat), long = mean(long))

# Define UI
ui <- fluidPage(
  titlePanel("US Map"),
  sidebarLayout(
    sidebarPanel(
      selectInput("states_input", "Select states:",
                  choices = sort(unique(us_states$region)),
                  multiple = TRUE)
    ),
    mainPanel(
      plotOutput("map")
    )
  )
)

# Define server
server <- function(input, output) {
  
  # Reactive data for selected states
  selected_states <- reactive({
    us_states %>%
      filter(region %in% input$states_input) %>%
      group_by(region) %>%
      summarise(lat = mean(lat), long = mean(long))
  })
  
  # Render map
  output$map <- renderPlot({
    ggplot() +
      geom_polygon(data = us_states, aes(x = long, y = lat, group = group),
                   fill = "grey80", colour = "white") +
      geom_point(data = selected_states(), aes(x = long, y = lat),
                 size = 3, colour = "red") +
      coord_quickmap() +
      theme_void()
  })
}

# Run the app
shinyApp(ui = ui, server = server)



#--------------------------------------------------------------------------------

##Attempt 2 - filter on states that are selected

library(shiny)
library(ggplot2)
library(tidyverse)
library(maps)

# Load US state data and state centroids
us_states <- map_data("state")
state_centroids <- us_states %>%
  group_by(region) %>%
  summarise(lat = mean(lat), long = mean(long))

# Define UI
ui <- fluidPage(
  titlePanel("US Map"),
  sidebarLayout(
    sidebarPanel(
      selectInput("states_input", "Select states:",
                  choices = sort(unique(us_states$region)),
                  multiple = TRUE)
    ),
    mainPanel(
      plotOutput("map")
    )
  )
)

# Define server
server <- function(input, output) {
  
  # Reactive data for selected states
  selected_states <- reactive({
    us_states %>%
      filter(region %in% input$states_input) %>%
      group_by(region) %>%
      summarise(lat = mean(lat), long = mean(long))
  })
  
  # Render map
  output$map <- renderPlot({
    ggplot() +
      geom_polygon(data = us_states %>% filter(region %in% input$states_input),
                   aes(x = long, y = lat, group = group),
                   fill = "grey80", colour = "white") +
      geom_point(data = selected_states(), aes(x = long, y = lat),
                 size = 3, colour = "red") +
      coord_quickmap() +
      theme_void()
  })
}


# Run the app
shinyApp(ui = ui, server = server)


#-----------------------------------------------------------------------------------------
##Attempt 3 - filter on states that are selected along with the regions

library(shiny)
library(ggplot2)
library(tidyverse)
library(maps)

# Load US state data and state centroids
us_states <- map_data("state")
state_centroids <- us_states %>%
  group_by(region) %>%
  summarise(lat = mean(lat), long = mean(long))

# Define UI
ui <- fluidPage(
  titlePanel("US Map"),
  sidebarLayout(
    sidebarPanel(
      selectInput("states_input", "Select states:",
                  choices = sort(unique(us_states$region)),
                  multiple = TRUE)
    ),
    mainPanel(
      plotOutput("map")
    )
  )
)
server <- function(input, output) {
  
  # Load US states data
  us_states <- map_data("state")
  
  # Define regions data
  us_regions <- data.frame(Region = c("New England", "Mid-Atlantic", "South", "Midwest", "Mountain", "Pacific"),
                           States = list(c("ME", "VT", "NH", "MA", "CT", "RI"),
                                         c("NY", "NJ", "PA", "DE", "MD", "DC", "VA", "WV"),
                                         c("NC", "SC", "GA", "FL", "KY", "TN", "AL", "MS", "AR", "LA", "TX", "OK"),
                                         c("OH", "MI", "IN", "IL", "WI", "MN", "IA", "MO", "ND", "SD", "NE", "KS"),
                                         c("MT", "ID", "WY", "NV", "UT", "CO", "AZ", "NM"),
                                         c("WA", "OR", "CA", "AK", "HI")))
  
  # Reactive data for selected region
  selected_region <- reactive({
    us_states %>%
      filter(region %in% unlist(us_regions$States[us_regions$Region == input$states_input])) %>%
      group_by(region) %>%
      summarise(lat = mean(lat), long = mean(long))
  })
  
  # Reactive data for selected state
  selected_state <- reactive({
    us_states %>%
      filter(state == input$states_input) %>%
      group_by(state) %>%
      summarise(lat = mean(lat), long = mean(long))
  })
  
  # Render map
  output$map <- renderPlot({
    ggplot() +
      geom_polygon(data = us_states %>% filter(region %in% unlist(us_regions$States[us_regions$Region == input$states_input])),
                   aes(x = long, y = lat, group = group),
                   fill = "grey80", colour = "white") +
      geom_point(data = selected_state(), aes(x = long, y = lat),
                 size = 3, colour = "red") +
      coord_quickmap() +
      theme_void()
  })
  
}

# Run the app
shinyApp(ui = ui, server = server)
