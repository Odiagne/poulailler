options(encoding="utf-8")
library(shiny)
source("fonctions.R")
server <- function(input, output, session) {
  output$effBande1 <- renderValueBox({
    valueBox(
      value = 0,
      subtitle = h4("Éléments de bande 1"),
      color ='yellow'
    )
  })
  
  output$effBande2 <- renderValueBox({
    valueBox(
      # value = paste0(formatC(0, format = "f", digits = 0), "%"),
      value = 0,
      subtitle = h4("Éléments de bande 2"),
      color ='yellow'
    )
  })
  
  output$effBande3 <- renderValueBox({
    valueBox(
      value = 0,
      subtitle =h4("Éléments de bande 3"),
      color ='yellow'
    )
  })
  
  output$depBande1 <- renderValueBox({
    valueBox(
      value = 0,
      subtitle = h4("F CFA de charges variables en bande 1"),
      color ='aqua'
    )
  })
  
  output$depBande2 <- renderValueBox({
    valueBox(
      value = 0,
      subtitle = h4("F CFA de charges variables en bande 2"),
      color ='aqua'
    )
  })
  
  output$depBande3 <- renderValueBox({
    valueBox(
      value = 0,
      subtitle = h4("F CFA de charges variables en bande 3"),
      color ='aqua'
    )
  })
  
  output$prevBande1 <- renderValueBox({
    valueBox(
      value = 0,
      subtitle = h4("Prix de revient unitaire bande 1"),
      color ='aqua'
    )
  })
  
  output$prevBande2 <- renderValueBox({
    valueBox(
      value = 0,
      subtitle = h4("Prix de revient unitaire bande 2"),
      color ='aqua'
    )
  })
  
  output$prevBande3 <- renderValueBox({
    valueBox(
      value = 0,
      subtitle = h4("Prix de revient unitaire bande 3"),
      color ='aqua'
    )
  })
  
  observeEvent(input$validerDebutBande, {
    add_bande(input$dateDebutBande, input$nombreElementsBande, input$prixAchat)
  })
  
  observeEvent(input$validerDepense, {
    add_depense(input$numBandeDep, input$typeDepense, input$coutDep, input$dateDepense)
  })
  # output$rep_puissanceInstallee <- renderPlotly({rep_puissanceInstallee})  
  # output$rep_autoconso <- renderPlotly({rep_autoconsommation})
  # output$rep_autonomie <- renderPlotly({rep_autonomie})
  # output$comp_productible <- renderPlotly({box_productible})
  # output$comp_autoconso <- renderPlotly({box_autoconso})
  # output$comp_conso <- renderPlotly({box_conso})
  # output$comp_autonomie <- renderPlotly({box_autonomie})
  # output$valfinUnitaire <- renderPlotly({box_valfinUnitaire})
  # output$valfin <- renderPlotly({box_valfin})
  
  # kpi <-reactive({input$selKPI})
  # observeEvent(input$selKPI, {session$sendCustomMessage(type="jsondata",kpi())})
  
}
#library(shinySignals)   # devtools::install_github("hadley/shinySignals")
# library(dplyr)
# library(shinydashboard)
#library(bubbles)        # devtools::install_github("jcheng5/bubbles")









