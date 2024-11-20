library(shiny)
library(tidyverse)
library(DT)
library(plotly)
library(shinythemes)
library(here)

# Load the dataset
drinks <- read_csv(here::here("data", "caffeine.csv"), show_col_types = FALSE)

ui <- fluidPage(

  # Change the theme
  theme = shinytheme("flatly"),

  # Title
  titlePanel("Drinks Dataset Explorer"),

  # Sidebar
  sidebarLayout(
    sidebarPanel(

      # Feature #1: Grouped checkbox to filter by individual drink types. This feature enables users to filter the dataset by drink type, making it easier to compare drinks across different categories or analyze caffeine content within specific groups
      checkboxGroupInput("drink_type", "Select Drink Type(s):",
                         choices = c("Coffee", "Energy Drinks", "Energy Shots", "Soft Drinks", "Tea", "Water"),
                         selected = c("Coffee", "Energy Drinks")),

      # Feature #2A: Slider to filter based on the volume (ml). This feature helps users filter for drinks that meet their specific preferences or needs, such as finding drinks with high caffeine content or within a specific volume range.
      sliderInput("volume", "Volume (ml):",
                  min = 0, max = max(drinks$volume_ml), value = c(0, 1000), step = 10),

      # Feature #2B: Slider to filter based on caffeine content (mg). This feature helps users filter for drinks that meet their specific preferences or needs, such as finding drinks with high caffeine content or within a specific volume range.
      sliderInput("caffeine", "Caffeine (mg):",
                  min = 0, max = max(drinks$caffeine_mg), value = c(0, 1200), step = 10),

      # Feature #3: Button to download the filtered data as a CSV. This feature is useful for users who want to save their filtered data for further analysis outside of the app, or share it with others.
      downloadButton("download_data", "Download Filtered Data as CSV")
    ),

    # Main panel
    mainPanel(
      # Add tabsets to divide the table and plot
      tabsetPanel(
        # Feature #4: Interactive data table using the DT package. An interactive table feature allows users to further explore within their filtered data by sorting variables or searching for included drinks.
        tabPanel("Table",
                 DT::dataTableOutput("drink_table")),

        # Feature #5: Bubble Plot (Caffeine vs Volume with bubble size = calories). This plot provides an accessible overview of how different drinks compare in terms of caffeine amount and volume, allowing users to visually spot trends in their filtered data. Using Plotly's interactive features enables users to hover over individual points to view information, isolate specific drink types, save the plot and more.
        tabPanel("Bubble Plot",
                 plotlyOutput("bubble_plot"))
      )
    )
  )
)


server <- function(input, output) {

  # Filter based on user input from UI side and then save as filtered_data() using reactive
  filtered_data <- reactive({
    drinks_filtered <- drinks %>%
      filter(
        type %in% input$drink_type, # Filter drink type
        volume_ml >= input$volume[1] & volume_ml <= input$volume[2], # Filter volume slider
        caffeine_mg >= input$caffeine[1] & caffeine_mg <= input$caffeine[2] # Filter caffeine slider
      )


    return(drinks_filtered)  # Return the filtered dataset
  })

  # Render the interactive data table with the filtered data
  output$drink_table <- DT::renderDataTable({
    DT::datatable(filtered_data())
  })

  # Render the interactive bubble plot with Plotly
  output$bubble_plot <- renderPlotly({

    # Create plot with ggplot
    p <- ggplot(filtered_data(), aes(x = volume_ml, y = caffeine_mg,
                          size = calories, color = type, label = drink)) +
      # Add jitter plot to separate drinks with overlapping volume and caffeine values
      geom_jitter(width = 0.2, height = 0.1, alpha = 0.4) +
      # Scale the bubbles
      scale_size_continuous(range = c(1, 10), guide = "none") +
      labs(x = "Volume (ml)", y = "Caffeine (mg)", color = "Type", title = "Caffeine vs Volume (Bubble size represents calories)") +
      theme_minimal()

    # Display the drink type (label), caffeine value (x), volume (y) and calories (size) when hovering over a point
    ggplotly(p, tooltip = c("label", "x", "y", "size"))
  })

  # Download handler to save the filtered data as a CSV
  output$download_data <- downloadHandler(
    filename = function() {
      # File name
      "filtered_drinks.csv" },
    content = function(con) {
      # Write csv with filtered data
      write_csv(filtered_data(), con)
    }
  )
}

# Run the app
shinyApp(ui = ui, server = server)
