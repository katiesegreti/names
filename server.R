function(input, output, session) {


  rv <- reactiveValues()
  rv$names <-data.frame(name = character(), sex = character(), total = integer())
  rv$selected <- data.frame(name = character(), sex = character())

  year_start <- eventReactive(input$from_year, {
    input$from_year
  })

  year_end <- eventReactive(input$to_year, (
    input$to_year
  ))
  #capture name and sex of selected row for plotly
  selected_name <- eventReactive(input$name_table_rows_selected, (
    rv$names[input$name_table_rows_selected,1:2]
    
  ))
  #create dataframe of selected name's n by year
  name_by_year <- reactive({
    req(selected_name())
    years_name(selected_name()$name, selected_name()$sex, year_start(), year_end())
  })

  #message for main output section
  output$main_message <- renderUI({
    if(nrow(rv$names) > 0) {
      "Names that meet your criteria"
    } else { #if(input$starts == "" & input$ends == "" & input$contains == "") {
      HTML("Enter your search criteria to see names!")
    } #else { "No names found. Please try again."  }
  })
  #message 2 for the main section
  output$message_2 <- renderUI({
    if(nrow(rv$names) > 0) {
      HTML("Click on a name to see its popularity over time")
    } else {
      HTML("(You can leave any of the text fields blank)")
    }
  })

  #asterisk message
  output$asterisk <- renderUI({
    HTML(paste("* human baby, pet, fictional character, whatever!",
               "We use the {babynames} library, which includes names of babies 
               born in the US throughout the years as provided by the 
               US Social Security Administration", sep="<br/><br/>"))
  })
  
  #populate rv$names when button is clicked
  observeEvent(input$tbl_btn, {
    rv$names <- get_name_list(begins = input$starts, ends = input$ends, contains = input$contains,
                              gender = input$gender, start_year = year_start(), end_year = year_end())
  })


  output$name_table <- DT::renderDataTable({
    if(nrow(rv$names) > 0) {
      DT::datatable(data = rv$names,
                    options = list(pageLength = 10,
                                   lengthMenu = list(c(10, 25, 100, -1),
                                                     c("10", "25", "100", "All"))),
                    selection = list(mode = 'single', selected = 1),
                    rownames = FALSE) %>%
        DT::formatCurrency("total", currency = "", digits = 0, interval = 3, mark = ",")
    }


  })
  #plot tile
  output$plot_title <- renderUI({
    #HTML("hi")
    # if(nrow(rv$names) > 0) {
       HTML(paste("Popularity of the name ", selected_name()[1,1], " over time"))
    # } else {}
  })
  
  ##plotly
  output$name_plot <- renderPlotly(

    plot1 <- plotly::plot_ly(
      x = name_by_year()$year,
      y = name_by_year()$n,
      type = 'bar',
      marker = list(
        color = "#44A57C"
      )
      #color = ghibli_palette("LaputaMedium", 3) #I("red")
    )
  )

  output$name_plot1 <- renderPlot({
    ggplot(name_by_year(), aes(x = year, y = n)) +
      geom_col(color = "#44A57C")
  })

  #################TESTING SECTION###########
  output$testing <- renderUI({
    #str(kevin)
    #str(rv$names[input$name_table_rows_selected,1:2])
    #str(name_by_year())
    #str(selected_name()[1,1])
  })

}