#' Exercism addin
#'
#' This addin supports a number of interactions with exercism.io via an API.
#'
#' @export
exercism_addin <- function() {

  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("exercism.io"),
    miniUI::miniContentPanel(
      shiny::selectInput(
        "action", label = "Action",
        choices = c("fetch", "skip", "submit"),
        selected = "fetch"
      ),
      shiny::conditionalPanel(
        condition = "input.action != 'submit'",
        shiny::selectInput(
          "track", label = "Language Track",
          choices = c("r", "python", "javascript"),
          selected = "r"
        )
      ),
      shiny::conditionalPanel(
        condition = "input.action == 'submit'",
        h5(strong("Filepath")),
        shiny::verbatimTextOutput("active_file"),
        actionButton("refresh_file", "Refresh", icon = icon("refresh")),
        helpText("Open the file in the RStudio's source viewer & refresh before submitting.")
      ),
      shiny::conditionalPanel(
        condition = "input.action != 'submit'",
        shiny::textInput(
          "slug", label = "Problem Slug",
          placeholder = "hello-world"
        )
      ),
      shiny::conditionalPanel(
        condition = "input.action != 'submit' && input.slug == ''",
        helpText("Please enter the problem slug above.")
      ),
      shiny::conditionalPanel(
        condition = "input.slug != '' || input.action == 'submit'",
        shiny::uiOutput("action_button")
      )
    )
  )

  server <- function(input, output, session) {

    output$action_button <- shiny::renderUI({

      shiny::actionButton("apply_action",
        label = switch(input$action,
                  "fetch"  = "Fetch exercise",
                  "skip"   = "Skip exercise",
                  "submit" = "Submit exercise"),
        icon = switch(input$action,
                  "fetch"  = shiny::icon("download"),
                  "skip"   = shiny::icon("fast-forward"),
                  "submit" = shiny::icon("upload"))
      )

    })
    
    file_to_submit <- reactive({
      input$refresh_file
      rstudioapi::getSourceEditorContext()$path
    })
    
    output$active_file <- shiny::renderText({
      file_to_submit()
    })
    
    shiny::observeEvent(input$done, {
      shiny::stopApp()
    })

    shiny::observeEvent(input$apply_action, {

      switch(input$action,

        "fetch"  = tryCatch({
          fetch_problem(track_id = input$track, slug = input$slug)
        },
        error = function(e) {
          message(e$message)
        },
        warning = function(w) {
          message(w$message)
        }),

        "skip"   = tryCatch({
          skip_problem(track_id = input$track, slug = input$slug)
        },
        error = function(e) {
          message(e$message)
        },
        warning = function(w) {
          message(w$message)
        }),

        "submit" = tryCatch({
          submit(file_to_submit())
        },
        error = function(e) {
          message(e$message)
        },
        warning = function(w) {
          message(w$message)
        })
      )
    })

  }

  shiny::runGadget(ui, server)

}
