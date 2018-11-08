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
  
  output$recBande1 <- recBande(stat_bande1, 1)
  output$recBande2 <- recBande(stat_bande2, 2)
  output$recBande3 <- recBande(stat_bande3, 3)
  
  observeEvent(input$Refresh, {
    summaryUpdate(stat_bande1, stat_bande2, stat_bande3, output)
  })
  
  observeEvent(input$validerDebutBande, {
    add_bande(input$dateDebutBande, input$nombreElementsBande, input$prixAchat)
    shinyalert("Success!", "Bande initialisée", type = "success")
    summaryUpdate(stat_bande1, stat_bande2, stat_bande3, output)
    listeDepUpdate(input, output)
    listePerteUpdate(input, output)
    listeVenteUpdate(input, output)
    refresh_historique(output)
  })
  
  observeEvent(input$validerFinBande, {
    # stat_bande1 = cal_stat_bande1()
    # stat_bande2 = cal_stat_bande2()
    # stat_bande3 = cal_stat_bande3()
    # summaryUpdate(stat_bande1, stat_bande2, stat_bande3, output)
    if (input$numBandeCloture == 1){
      numBandeCloture <- stat_bande1$numBande
    } else if (input$numBandeCloture == 2){
      numBandeCloture <- stat_bande2$numBande
    } else if (input$numBandeCloture == 3){
      numBandeCloture <- stat_bande3$numBande
    }
    end_bande(numBandeCloture, input$dateFinBande, input$remarquesClos)
    shinyalert("Success!", "Bande cloturée", type = "success")
    summaryUpdate(stat_bande1, stat_bande2, stat_bande3, output)
    listeDepUpdate(input, output)
    listePerteUpdate(input, output)
    listeVenteUpdate(input, output)
    refresh_historique(output)
  })
  
  observeEvent(input$validerDepense, {
    if (input$numBandeDep == 1){
      numBandeDep <- stat_bande1$numBande
    } else if (input$numBandeDep == 2){
      numBandeDep <- stat_bande2$numBande
    } else if (input$numBandeDep == 3){
      numBandeDep <- stat_bande3$numBande
    }
    print(input$numBandeDep)
    print(numBandeDep)
    print(stat_bande3$numBande)
    print(stat_bande3)
    shinyalert("Success!", "Dépense enregistrée", type = "success")
    add_depense(numBandeDep, input$typeDepense, input$coutDep, input$dateDepense, input$remarques)
    summaryUpdate(stat_bande1, stat_bande2, stat_bande3, output)
    listeDepUpdate(input, output)
    updateSelectInput(session, "selTabDep", selected = input$numBandeDep)
  })

  observeEvent(input$selTabDep, {
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
    summaryUpdate(stat_bande1, stat_bande2, stat_bande3, output)
    listeDepUpdate(input, output)
  })
  
  observeEvent(input$supprimerDepense, {
    supDepense(input$idDepSup)
    shinyalert("Success!", "Dépense supprimée", type = "success")

    listeDepUpdate(input, output)
    summaryUpdate(stat_bande1, stat_bande2, stat_bande3, output)
  })
  

  # observeEvent(input$validerMortalite, {
  #   add_mort(input$numBandeMort, input$nbMort, input$dateMort, input$remarquesMort)
  #   shinyalert("Success!", "Perte enregistrée", type = "success")
  #   listePerteUpdate(input, output)
  #   summaryUpdate(stat_bande1, stat_bande2, stat_bande3, output)
  # })

  observeEvent(input$validerMortalite, {
    if (input$numBandeMort == 1){
      numBandeMort <- stat_bande1$numBande
    } else if (input$numBandeMort == 2){
      numBandeMort <- stat_bande2$numBande
    } else if (input$numBandeMort == 3){
      numBandeMort <- stat_bande3$numBande
    }
    shinyalert("Success!", "Perte enregistrée", type = "success")
    add_mort(numBandeMort, input$nbMort, input$dateMort, input$remarquesMort)
    summaryUpdate(stat_bande1, stat_bande2, stat_bande3, output)
    listePerteUpdate(input, output)
    updateSelectInput(session, "selTabPerte", selected = input$numBandeMort)
  })
  
  observeEvent(input$selTabPerte, {
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
    summaryUpdate(stat_bande1, stat_bande2, stat_bande3, output)
    listePerteUpdate(input, output)
  })
 
  
  
  observeEvent(input$supprimerPerte, {
    supPerte(input$idPerteSup)
    shinyalert("Success!", "Perte supprimée", type = "success")
    
    listePerteUpdate(input, output)
    summaryUpdate(stat_bande1, stat_bande2, stat_bande3, output)
  })

  observeEvent(input$validerVente, {
    typeVente = ifelse(input$typeVente=="det", "AU DETAIL", "EN GROS")
    if (input$numBandeVente == 1){
      numBandeVente <- stat_bande1$numBande
    } else if (input$numBandeVente == 2){
      numBandeVente <- stat_bande2$numBande
    } else if (input$numBandeVente == 3){
      numBandeVente <- stat_bande3$numBande
    }
    shinyalert("Success!", "Vente enregistrée", type = "success")
    add_vente(numBandeVente, typeVente, input$prixVente*input$nbVendu, input$nbVendu, input$dateVente, input$remarquesVente)
    listeVenteUpdate(input, output)
    summaryUpdate(stat_bande1, stat_bande2, stat_bande3, output)
    updateSelectInput(session, "selTabVente", selected = input$numBandeVente)
  })
  
  # observeEvent(input$validerVente, {
  #   typeVente = ifelse(input$typeVente=="det", "AU DETAIL", "EN GROS")
  #   add_vente(input$numBandeVente, typeVente, input$prixVente*input$nbVendu, input$nbVendu, input$dateVente, input$remarquesVente)
  #   shinyalert("Success!", "Vente enregistrée", type = "success")
  #   
  #   listeVenteUpdate(input, output)
  #   summaryUpdate(stat_bande1, stat_bande2, stat_bande3, output)
  # })
  
  observeEvent(input$selTabVente, {
    venteToShow = input$selTabVente
    if (venteToShow == 1){
      output$tableauVente <- DT::renderDataTable({
        datatable(stat_bande1$tableau_ventes, rownames= FALSE)
      })
    } else if (venteToShow == 2){
      output$tableauVente <- DT::renderDataTable({
        datatable(stat_bande2$tableau_ventes, rownames= FALSE)
      })
    } else if (venteToShow == 3){
      output$tableauVente <- DT::renderDataTable({
        datatable(stat_bande3$tableau_ventes, rownames= FALSE)
      })
    }
    summaryUpdate(stat_bande1, stat_bande2, stat_bande3, output)
    listeVenteUpdate(input, output)
  })
  
  observeEvent(input$supprimerVente, {
    supVente(input$idVenteSup)
    shinyalert("Success!", "Vente supprimée", type = "success")
    
    listeVenteUpdate(input, output)
    summaryUpdate(stat_bande1, stat_bande2, stat_bande3, output)
  })
  
  output$tableauHistorique <- DT::renderDataTable({
    hist = aff_historique()
    datatable(hist, rownames= FALSE) })
  
  observeEvent(input$Refresh_historique, {
    refresh_historique(output)
  })
    
}









