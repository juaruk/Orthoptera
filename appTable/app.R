library(shiny)
library(DT)

# Define UI
ui <- fluidPage(
    mainPanel(
      style="text-align: center",
      DTOutput("interactiveTable")
    )
)

# Define Server
server <- function(input, output) {
  output$interactiveTable <- renderDT({
    file <- "OrthoFindertable2.csv"
    if (file.exists(file)) {
      data <- read.csv(file)
      for (i in 1:nrow(data)) {
        if (data[i, 6] != "") {
          data[i, 6] <- paste0("<a href='", data[i, 6], "' target='_blank'>yes</a>")
          # data[i, 6] <- paste0("<a href='yes'", data[i, 6], ">yes</a>")
        } else {
          data[i, 6] <- "no"
        }
      }
      datatable(data, options = list(pageLength = 10, autoWidth = TRUE), rownames=FALSE, escape=FALSE) %>%
        formatStyle(columns = colnames(data), fontSize = '85%') %>%
        formatStyle('Species', fontStyle = 'italic')
    } else {
      data.frame(Message = "File not found.")
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)
