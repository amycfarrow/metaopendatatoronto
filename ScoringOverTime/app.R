#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(opendatatoronto)
library(tidyverse)
library(shiny)
library(scales)
library(lubridate)

raw_data <-
    opendatatoronto::search_packages("Catalogue quality scores") %>%
    opendatatoronto::list_package_resources() %>%
    dplyr::filter(name %in% c("catalogue-scorecard")) %>%  # This is the name of the resource we are interested in.
    dplyr::select(id) %>%
    opendatatoronto::get_resource()

### Clean data ###
# This properly formats the collection time and date,
# renames the normalized grade to 'grade', as the nonnormalized grade is discarded,
# and renames the normalized quality score variable as 'quality'
cleaned_data <-
    raw_data %>% 
    select(package, 
           accessibility,
           completeness,
           freshness,
           metadata,
           usability,
           score,
           grade_norm,
           recorded_at) %>%
    mutate(recorded_at = as_datetime(recorded_at)) %>%
    rename(quality = score, grade = grade_norm, date_scored = recorded_at)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Open Data Toronto Data Scores"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput('type', 
                        "Which score would you like to see?",
                        choices = c("accessibility",
                                    "completeness",
                                    "freshness",
                                    "metadata",
                                    "usability",
                                    "quality"))
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("scorePlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$scorePlot <- renderPlot({
        
        cleaned_data %>%
            group_by(date_scored) %>%
            summarise(
                num_scored = n_distinct(package),
                mean = mean(eval(parse(text = input$type)))
            ) %>%
            
            ## Plotting the number of packages scored over time, with the average Quality score 
            ## shown using a color gradient. Lollipop graph uses point and segment.
            ggplot(aes(x = date_scored, y = num_scored, color = mean)) +
            geom_point(alpha = 0.7, size = 1) +
            geom_segment(aes(x = date_scored, xend = date_scored, y = 0, yend = num_scored), alpha = 0.7) +
            
            # Manipulate colors, labels, and scales for easier presentation:
            scale_color_gradientn(colors = c('firebrick1', 'darkorange', 'gold', 'chartreuse3', 'darkturquoise', 'royalblue2', 'magenta3', 'deeppink'),
                                  limits = c(0.3,1)) +
            
            scale_x_datetime(expand = c(0, 0),  # keep the sides of the plot snug to the limits
                             labels = date_format("%d%b\n%Y"),   # Format the x-axis scale to show month names
                             breaks = "month",
                             minor_breaks = NULL,  # Remove minor break lines
            ) +
            labs(color = "Average \nscore \nacross all \npackages",
                 x = "Date recorded",
                 y = "Number of packages scored",
                 title = "Scoring frequency and average scores of data packages on Open Data Toronto") + 
            theme_light()
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
