options(encoding="utf-8")
library(shiny)
require(shinyalert)
source("fonctions.R")

server <- function(input, output, session) {

  stat_bande1 = cal_stat_bande1()
  stat_bande2 = cal_stat_bande2()
  stat_bande3 = cal_stat_bande3()

  output$effBande1 <- eff_bande(stat_bande1, 1)
  output$effBande2 <- eff_bande(stat_bande2, 2)
  output$effBande3 <- eff_bande(stat_bande3, 3)

  output$nbJoursBande1 <- nbJoursBande(stat_bande1, 1)
  output$nbJoursBande2 <- nbJoursBande(stat_bande2, 2)
  output$nbJoursBande3 <- nbJoursBande(stat_bande3, 3)

  output$depBande1 <- depBande(stat_bande1, 1)
  output$depBande2 <- depBande(stat_bande2, 2)
  output$depBande3 <- depBande(stat_bande3, 3)

  output$prevBande1 <- prevBande(stat_bande1, 1)
  output$prevBande2 <- prevBande(stat_bande2, 2)
  output$prevBande3 <- prevBande(stat_bande3, 3)
  
  observeEvent(input$Refresh, {
    summaryUpdate(output)
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
    
    listeDepUpdate(input, output)
    summaryUpdate(output)
  })

  observe({
    depToShow = input$selTabDep
    if (depToShow == 1){
      output$tableauDep <- DT::renderDataTable({
        datatable(stat_bande1$tableau_depenses, rownames= FALSE)
      })
    } else if (depToShow == 2){
      output$tableauDep <- DT::renderDataTable({
        datatable(stat_bande2$tableau_depenses, rownames= FALSE)
      })
    } else if (depToShow == 3){
      output$tableauDep <- DT::renderDataTable({
        datatable(stat_bande3$tableau_depenses, rownames= FALSE)
      })
    }
  })
  
  observeEvent(input$supprimerDepense, {
    supDepense(input$idDepSup)
    shinyalert("Success!", "Dépense supprimée", type = "success")

    listeDepUpdate(input, output)
    summaryUpdate(output)
  })
  

  observeEvent(input$validerMortalite, {
    add_mort(input$numBandeMort, input$nbMort, input$dateMort, input$remarquesMort)
    shinyalert("Success!", "Perte enregistrée", type = "success")
    listePerteUpdate(input, output)
    summaryUpdate(output)
  })

  observe({
    perteToShow = input$selTabPerte
    if (perteToShow == 1){
      output$tableauPerte <- DT::renderDataTable({
        datatable(stat_bande1$tableau_pertes, rownames= FALSE)
      })
    } else if (perteToShow == 2){
      output$tableauPerte <- DT::renderDataTable({
        datatable(stat_bande2$tableau_pertes, rownames= FALSE)
      })
    } else if (perteToShow == 3){
      output$tableauPerte <- DT::renderDataTable({
        datatable(stat_bande3$tableau_pertes, rownames= FALSE)
      })
    }
  })
  
  observeEvent(input$supprimerPerte, {
    supPerte(input$idPerteSup)
    shinyalert("Success!", "Perte supprimée", type = "success")
    
    listePerteUpdate(input, output)
    summaryUpdate(output)
  })
  
  observeEvent(input$validerVente, {
    typeVente = ifelse(input$typeVente=="det", "AU DETAIL", "EN GROS")
    add_vente(input$numBandeVente, typeVente, input$prixVente*input$nbVendu, input$nbVendu, input$dateVente, input$remarquesVente)
    shinyalert("Success!", "Vente enregistrée", type = "success")
  })
  
  
}









