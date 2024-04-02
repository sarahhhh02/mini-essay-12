#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI
ui <- fluidPage(
  
  titlePanel("Holocaust Victims at Auschwitz Concentration Camp during 1941-1945"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("category", "Select Ethnic Origin:",
                         choices = c("Jews", "Poles", "Roma/Sinti", "Soviet POWs", "Others"),
                         selected = c("Jews", "Poles", "Roma/Sinti", "Soviet POWs", "Others"))
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Graph", plotOutput("plot")),
        tabPanel("Table", tableOutput("table"))
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Create dataset
  data <- data.frame(
    Victims = c("Jews", "Poles", "Roma/Sinti", "Soviet POWs", "Others"),
    Deaths = c(1000000, 72500, 21000, 15000, 12500)
  )
  
  # Reactive function to filter data based on user selection
  filtered_data <- reactive({
    data[data$Victims %in% input$category, ]
  })
  
  # Render plot
  output$plot <- renderPlot({
    filtered <- filtered_data()
    barplot(filtered$Deaths, names.arg = filtered$Victims,
            main = "Number of Auschwitz Victims by Ethinc Origin",
            xlab = "Ethnic Origin", ylab = "Number of Deaths",
            col = "grey")
  })
  
  
  # Render table
  output$table <- renderTable({
    filtered <- filtered_data()
    filtered
  }, rownames = FALSE)
}

# Run the application
shinyApp(ui = ui, server = server)
