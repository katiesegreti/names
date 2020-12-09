navbarPage(
  shiny::tags$head(
    
    shiny::tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  title = "the best baby name finder!",
      sidebarPanel(
        #class = "card",
        depth = 4,
        textInput(
          inputId = "starts",
          label = "starts with: "
        ),
        textInput(
          inputId = "ends",
          label = "ends with: "
        ),
        textInput(
          inputId = "contains",
          label = "contains pattern: "
        ),
        radioButtons(
          inputId = "gender",
          label = "Gender",
          choices = c(
            "girls" = "F",
            "boys" = "M",
            "both" = "both"),
          selected = "both"
        ),
        sliderInput(
          inputId = "from_year",
          label = "From Year",
          min = 1880,
          max = 2016,
          sep = "",
          value = 1880
        ),
        sliderInput(
          inputId = "to_year",
          label = "Through Year",
          min = 1881,
          max = 2017,
          sep = "",
          value = 2017
        ),
        actionButton(
          inputId = "tbl_btn",
          label = "search names"
        )
        ,
        br(),
        uiOutput("asterisk")
      ),
     mainPanel(
        class = "class",
        uiOutput("main_message"),
        uiOutput("message_2"),
        
        plotly::plotlyOutput("name_plot"),
        #title = "Names that meet your criteria: ",
        DT::dataTableOutput(outputId = "name_table"),
        uiOutput("testing"),
        br(),
        br(),
        uiOutput("plot_title"),
        plotOutput("name_plot1")#,
        

      )

   
  
)