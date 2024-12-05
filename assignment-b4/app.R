# Install the required packages before loading
library(shiny)
library(survival)
library(survminer)
library(tidyverse)
library(shinythemes)


# UI
ui <- fluidPage(

  # Theme
  theme = shinytheme("flatly"),

  # Title
  titlePanel("Survival Plot Maker: Customizable Survival Analysis Graphs"),

  sidebarLayout(
    sidebarPanel(

      # Feature 1: Dynamic UI for number of groups. This feature makes it easier for users to paste different subgroups, with the app changing the number of input boxes based on the slider.
      h3("1. Select number of groups"),
      sliderInput("num_groups", "Number of groups", min = 1, max = 5, value = 2),

      h3("2. Input your time-to-event and censor data"),
      h5("Please enter one value per row for both."),
      uiOutput("group_inputs"),

      # Feature 2: Plot customization options. This feature allows users to fully customize their plot through adding or removing confidence intervals, calculating a p-value if >1 group, including a risk table or giving the plot a title.
      h3("3. Customize plot features"),
      checkboxInput("show_ci", "Show Confidence Intervals", TRUE),
      checkboxInput("show_pval", "Show p-value (log rank test)", FALSE),
      checkboxInput("show_risk_table", "Show Risk Table", TRUE),
      textInput("plot_title", "Plot Title", "Survival Plot"),
      selectInput("time_unit", "Unit of Time (x-axis)", choices = c("Days", "Months", "Years"), selected = "Months"),


      h3("4. Generate your plot"),
      actionButton("generate_plot", "Generate Plot"),
      h3("5. Download plot as PNG"),
      downloadButton("download_plot", "Download as .png")
    ),

    mainPanel(
      plotOutput("surv_plot")


    )
  )
)

# Server
server <- function(input, output, session) {

  # Dynamically generate input fields for each group based on the number selected
  output$group_inputs <- renderUI({

    # Create an empty list to store input elements in as we iterate through the group numbers
    group_inputs <- list()

    for (i in 1:input$num_groups) {

      # Save group name as an object for labelling below
      group_name <- str_c("Group ", i)

    # Create a wellPanel for each group with input fields
      group_inputs[[i]] <- wellPanel(


        # Create a header for each group using group_name
        h4(group_name),

        # Create and label text box for the user to name the group, with "Group i" as the default value
        # Input ID is saved as "group_name_i"
        textInput(str_c("group_name_", i), label = str_c(group_name, " Name"), value = group_name),

        # Create text boxes to input time-to-event and censoring data, with helpful placeholder comments for inputting data
        # Input IDs are saved as "time_i" for time-to-event boxes and "censor_i" for censor data boxes
        textAreaInput(str_c("time_", i), label = str_c("Time-to-event Data for ", group_name), rows = 10, placeholder = "Enter one time value per row"),
        textAreaInput(str_c("censor_", i), label = str_c("Censoring Data for ", group_name), rows = 10, placeholder = "Enter one censor value per row (0 = censored, 1 = event)")
      )
    }

    return(group_inputs)
  })

  # Collect and process the inputted data into a tibble for analysis
  survival_data <- reactive({

    # Create an empty tibble to fill inputted data
    combined_data <- tibble()

    # Collect and process time-to-event data for each group
    for (i in 1:input$num_groups) {
      time_data <- input[[str_c("time_", i)]] %>% # Retrieve the input based on the dynamic group input IDs created above. Ex: "time_1", "time_2"
        str_split("\n") %>%  # Split the string by newline
        unlist() %>%        # Convert from a list into a numeric vector
        as.numeric()

      # Collect and process censor data for group
      censor_data <- input[[str_c("censor_", i)]] %>%
        str_split("\n") %>%
        unlist() %>%
        as.numeric()

      # Collect corresponding group data
      group_data <- input[[str_c("group_name_", i)]]

      # Check if time-to-event and censor data lengths are equal, otherwise create a warning notification
      if (length(time_data) != length(censor_data)) {
        showNotification("Time and censoring data lengths must match for each group.", type = "error")
        return(NULL)
      }

      # Store time-to-event, censor and group data into a tibble
      collected_data <- tibble(survival_time = time_data, status = censor_data, group = as.factor(group_data))
      # Bind our new tibble to the previously collected empty one. This was done due to errors occurring in the For loop otherwise.
      combined_data <- bind_rows(combined_data, collected_data)

    }
    return(combined_data)
  })

  # Feature 3: Survival curve. After inputting their data and customizing fields, the Shiny App generates a customized survival plot with added features and a colorblind-friendly palette to view or download.
  plot_reactive <- reactive({
    # Require the user to click the "generate plot" button before generating the initial plot
    req(input$generate_plot)

    # Save the survival_data reactive function in an object that is easier to work with
    data <- survival_data()

    # Create a survival object
    survival_object <- Surv(time = data$survival_time, event = data$status)

    # Create survival curves using the Kaplan-Meier formula. Credit to user12728748 on Stackoverflow for solving an issue when generating the survival curves within Shiny
    # Link to solved question: https://stackoverflow.com/questions/72204583/ggsurvplot-in-shiny-error-when-p-value-true
    fit <- do.call(survfit, list(formula = survival_object ~ group, data = data))

    # Update classic theme to include title in the center of the plot and bold the text and lines
    surv_theme = theme_classic() + theme(
      plot.title = element_text(hjust = 0.5, face = "bold"),
      axis.title = element_text(face = "bold"),
      axis.text = element_text(face = "bold"),
      legend.text = element_text(face = "bold"),
      legend.title = element_text(face = "bold"),
      axis.line = element_line(size = 0.6)
    )


    # Generate the survival plot using ggsurvplot
    ggsurvplot(
      fit = fit,
      data = data,
      title = input$plot_title,
      xlab = str_c("Time (", input$time_unit, ")", sep = ""),
      ylab = "Survival Probability",
      conf.int = input$show_ci,
      pval = input$show_pval,
      risk.table = input$show_risk_table,
      risk.table.col = "strata",
      legend.title = "",
      legend.labs = levels(data$group),
      ggtheme = surv_theme,
      palette = c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2") # Custom colorblind-friendly palette
    )
  })

  # Render and display the plot
  output$surv_plot <- renderPlot({
    plot_reactive()
  })

  # Download the plot as .png
  output$download_plot <- downloadHandler(
    filename = function() {
      str_c(input$plot_title, ".png")
    },
    content = function(file) {

      # The code inputs an error when using ggsave() to save the plot and risk table together if that option is selected. An alternative method was used instead to avoid this.
      png(file, width = 8, height = 6, units = "in", res = 300)
      print(plot_reactive())
      dev.off()
    }
  )
}


shinyApp(ui = ui, server = server)

