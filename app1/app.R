library(shiny)
library(bslib)
library(ggplot2)

# Define UI
ui <- page_sidebar(
  sidebar = sidebar(
    # Select variable for y-axis
    selectInput(
      inputId = "y",
      label = "Y-axis:",
      choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
      selected = "audience_score"
    ),
    # Select variable for x-axis
    selectInput(
      inputId = "x",
      label = "X-axis:",
      choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
      selected = "critics_score"
    )
  ),
  # Output: Show scatterplot
  card(plotOutput(outputId = "scatterplot"))
)

# Define server
server <- function(input, output, session) {
  movies <- read.csv('movies.csv')
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y)) +
      geom_point()
  })
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
