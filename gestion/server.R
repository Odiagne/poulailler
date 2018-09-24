options(encoding="utf-8")
library(shiny)
require(shinyalert)
source("fonctions.R")

server <- function(input, output, session) {

  stat_bande1 = cal_stat_bande1()

  output$effBande1 <- eff_bande(stat_bande1, 1)
  
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
  
  output$nbJoursBande1 <- nbJoursBande(stat_bande1, 1)
  
  output$nbJoursBande2 <- renderValueBox({
    valueBox(
      value = 0,
      subtitle = h4("Jours pour la bande 2"),
      color ='aqua'
    )
  })
  
  output$nbJoursBande3 <- renderValueBox({
    valueBox(
      value = 0,
      subtitle = h4("Jours pour la bande 3"),
      color ='aqua'
    )
  })
  
  output$depBande1 <- depBande(stat_bande1, 1)
  
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
  
  output$prevBande1 <- prevBande(stat_bande1, 1)
  
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
  
  observeEvent(input$Refresh, {
    stat_bande1 = cal_stat_bande1()
    output$effBande1 <- eff_bande(stat_bande1, 1)
    output$depBande1 <- depBande(stat_bande1, 1)
    output$prevBande1 <- prevBande(stat_bande1, 1)
  })
  
  observeEvent(input$validerDebutBande, {
    add_bande(input$dateDebutBande, input$nombreElementsBande, input$prixAchat)
    shinyalert("Success!", "Bande initialisée", type = "success")
  })
  
  observeEvent(input$validerFinBande, {
    end_bande(input$numBandeCloture, input$dateFinBande, input$remarquesClos)
    shinyalert("Success!", "Bande cloturée", type = "success")
  })
  
  observeEvent(input$validerDepense, {
    add_depense(input$numBandeDep, input$typeDepense, input$coutDep, input$dateDepense, input$remarques)
    shinyalert("Success!", "Dépense enregistrée", type = "success")
  })
  
  observeEvent(input$validerMortalite, {
    add_mort(input$numBandeMort, input$nbMort, input$dateMort, input$remarquesMort)
    shinyalert("Success!", "Perte enregistrée", type = "success")
  })
  
}









