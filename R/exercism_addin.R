#' Exercism addin
#'
#' This addin supports a number of interactions with exercism.io via an API.
#'
#' @export
exercism_addin <- function() {

  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("exercism.io"),
    miniUI::miniContentPanel(
      shiny::inputPanel(
        shiny::selectInput(
          "action", label = "Action",
          choices = c("fetch", "skip", "submit"),
          selected = "fetch"
        ),
        shiny::selectInput(
          "track", label = "Language Track",
          choices = c("r", "python", "javascript", "bash", "c", "cpp"),
          selected = "r"
        ),
        shiny::conditionalPanel(
          condition = "input.action == 'submit'",
          shiny::textInput(
            "solution", label = "Path to Solution",
            placeholder = "C:/Users/Bob/exercism/r/hello-world.R"
          )
        ),
        shiny::conditionalPanel(
          condition = "input.action != 'submit'",
          shiny::textInput(
            "slug", label = "Problem Slug",
            placeholder = "hello-world"
          )
        ),
        shiny::conditionalPanel(
          condition = "input.slug != '' || input.solution != ''",
          shiny::uiOutput("action_button")
        )
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

        "submit" = message("Sorry, submit functionality is not available yet.")

      )

    })

  }

  shiny::runGadget(ui, server)

}
