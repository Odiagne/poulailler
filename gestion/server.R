options(encoding="utf-8")
library(shiny)
require(shinyalert)
source("fonctions.R")

server <- function(input, output, session) {

  stat_bande1 = cal_stat_bande1()

  output$effBande1 <- eff_bande(stat_bande1, 1)
  
  stat_bande2 = cal_stat_bande2()
  output$effBande2 <- eff_bande(stat_bande2, 2)
  # output$effBande2 <- renderValueBox({
  #   valueBox(
  #     # value = paste0(formatC(0, format = "f", digits = 0), "%"),
  #     value = 0,
  #     subtitle = h4("Éléments de bande 2"),
  #     color ='purple'
  #   )
  # })
  
  stat_bande3 = cal_stat_bande3()
  output$effBande3 <- eff_bande(stat_bande3, 3)
  
  # output$effBande3 <- renderValueBox({
  #   valueBox(
  #     value = 0,
  #     subtitle =h4("Éléments de bande 3"),
  #     color ='olive'
  #   )
  # })
  

  output$nbJoursBande1 <- nbJoursBande(stat_bande1, 1)
  
  output$nbJoursBande2 <- nbJoursBande(stat_bande2, 2)
  # output$nbJoursBande2 <- renderValueBox({
  #   valueBox(
  #     value = 0,
  #     subtitle = h4("Jours pour la bande 2"),
  #     color ='purple'
  #   )
  # })
  output$nbJoursBande3 <- nbJoursBande(stat_bande3, 3)
  # output$nbJoursBande3 <- renderValueBox({
  #   valueBox(
  #     value = 0,
  #     subtitle = h4("Jours pour la bande 3"),
  #     color ='olive'
  #   )
  # })
  
  output$depBande1 <- depBande(stat_bande1, 1)
  
  output$depBande2 <- depBande(stat_bande2, 2)
  # output$depBande2 <- renderValueBox({
  #   valueBox(
  #     value = 0,
  #     subtitle = h4("F CFA de charges variables en bande 2"),
  #     color ='purple'
  #   )
  # })
  output$depBande3 <- depBande(stat_bande3, 3)
  # output$depBande3 <- renderValueBox({
  #   valueBox(
  #     value = 0,
  #     subtitle = h4("F CFA de charges variables en bande 3"),
  #     color ='olive'
  #   )
  # })
  
  output$prevBande1 <- prevBande(stat_bande1, 1)
  
  output$prevBande2 <- prevBande(stat_bande2, 2)
  # output$prevBande2 <- renderValueBox({
  #   valueBox(
  #     value = 0,
  #     subtitle = h4("Prix de revient unitaire bande 2"),
  #     color ='purple'
  #   )
  # })
  output$prevBande3 <- prevBande(stat_bande3, 3)
  # output$prevBande3 <- renderValueBox({
  #   valueBox(
  #     value = 0,
  #     subtitle = h4("Prix de revient unitaire bande 3"),
  #     color ='olive'
  #   )
  # })
  
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
  
  observeEvent(input$validerVente, {
    typeVente = ifelse(input$typeVente=="det", "AU DETAIL", "EN GROS")
    add_vente(input$numBandeVente, typeVente, input$prixVente, input$nbVendu, input$dateVente, input$remarquesVente)
    shinyalert("Success!", "Vente enregistrée", type = "success")
  })
  
}









