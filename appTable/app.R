library(shiny)
library(DT)

file <- "OrthoFindertable2.csv"
if (file.exists(file)) {
  data <- read.csv(file)
  copychoices <- 5:(ncol(data) -1)
  names(copychoices) <- names(data)[5:(ncol(data)-1)]
} else{
  data.frame(Message = "File not found.")
  copychoices <- NULL
}


# Define UI
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      width = 3,
      checkboxGroupInput("columns", "Select Columns", choices = copychoices, inline = TRUE),
    ),

    mainPanel(
      style = "text-align: center",
      width = 9,
      DTOutput("interactiveTable")
    )
  )
)

# Define Server
server <- function(input, output) {
  output$interactiveTable <- renderDT({
    selected_columns <- c(1, 2, 3, 4, as.numeric(input$columns))
    for (i in 1:nrow(data)) {
      if (data[i, 6] != "") {
        data[i, 6] <- paste0("<a href='", data[i, 6], "' target='_blank'>yes</a>")
      } else {
        data[i, 6] <- "no"
      }
    }
    selected_columns <- c(1, 2, 3, 4, as.numeric(input$columns))
    display_data <- data[, selected_columns, drop = FALSE]
    datatable(display_data, options = list(pageLength = 10, autoWidth = TRUE), rownames=FALSE, escape=FALSE) %>%
      formatStyle(columns = colnames(display_data), fontSize = '85%') %>%
      formatStyle('Species', fontStyle = 'italic')
  })
}

# Run the application
shinyApp(ui = ui, server = server)
