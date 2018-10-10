require(RMySQL)
require(lubridate)
add_bande = function(date_debut, nombre, prix_achat){
  con <- dbConnect(RMySQL::MySQL(), host = "server.odiagne.com",
                   user = "aviculteur", password = "diagne-avi")
  
  query = paste0('INSERT INTO AVICULTURE.BANDES(DATE_DEBUT, NOMBRE, PRIX_ACHAT) VALUES("', date_debut, '", ', nombre, ', ', prix_achat,")") 
  dbGetQuery(con, query)
  dbDisconnect(con)
}

end_bande = function(numBandeCloture, dateFinBande, remarques){
  con <- dbConnect(RMySQL::MySQL(), host = "server.odiagne.com",
                   user = "aviculteur", password = "diagne-avi")
  query = paste0('UPDATE AVICULTURE.BANDES SET DATE_FIN = "', dateFinBande, '", REMARQUES = "', remarques, '" WHERE BANDE = ', numBandeCloture)
  dbGetQuery(con, query)
  dbDisconnect(con)
}

add_depense = function(bande, type, cout, date, remarque){
  con <- dbConnect(RMySQL::MySQL(), host = "server.odiagne.com",
                   user = "aviculteur", password = "diagne-avi")
  
  query = paste0('INSERT INTO AVICULTURE.DEPENSES(BANDE, TYPE, COUT, DATE, REMARQUES) VALUES(', bande, ', "', type, '", ', cout, ', "', date, '", "', remarque,'")') 
  dbGetQuery(con, query)
  dbDisconnect(con)
}

supDepense = function(id_dep){
  con <- dbConnect(RMySQL::MySQL(), host = "server.odiagne.com",
                   user = "aviculteur", password = "diagne-avi")
  
  query = paste0('DELETE FROM AVICULTURE.DEPENSES WHERE ID = "', id_dep, '"')
  dbGetQuery(con, query)
  dbDisconnect(con)
}

supPerte = function(id_perte){
  con <- dbConnect(RMySQL::MySQL(), host = "server.odiagne.com",
                   user = "aviculteur", password = "diagne-avi")
  
  query = paste0('DELETE FROM AVICULTURE.MORTALITE WHERE ID = "', id_perte, '"')
  dbGetQuery(con, query)
  dbDisconnect(con)
}

supVente = function(id_vente){
  con <- dbConnect(RMySQL::MySQL(), host = "server.odiagne.com",
                   user = "aviculteur", password = "diagne-avi")
  
  query = paste0('DELETE FROM AVICULTURE.VENTES WHERE ID = "', id_vente, '"')
  dbGetQuery(con, query)
  dbDisconnect(con)
}

add_mort = function(bande, nb_morts, date, remarque){
  con <- dbConnect(RMySQL::MySQL(), host = "server.odiagne.com",
                   user = "aviculteur", password = "diagne-avi")
  
  query = paste0('INSERT INTO AVICULTURE.MORTALITE(BANDE, NOMBRE_MORTS, DATE, REMARQUES) VALUES(', bande, ', ', nb_morts, ', "', date, '", "', remarque, '")') 
  dbGetQuery(con, query)
  dbDisconnect(con)
}

add_vente = function(bande, type, prix, nombre_vendu, date, remarque){
  con <- dbConnect(RMySQL::MySQL(), host = "server.odiagne.com",
                   user = "aviculteur", password = "diagne-avi")
  
  query = paste0('INSERT INTO AVICULTURE.VENTES(BANDE, TYPE, PRIX, NOMBRE_VENDU, DATE, REMARQUES) VALUES(', bande, ', "', type, '", ', prix, ', ', nombre_vendu, ', "', date, '", "', remarque, '")') 
  dbGetQuery(con, query)
  dbDisconnect(con)
}


summarise_infos = function(infos_bande, con){
  if(nrow(infos_bande)>0){
    numBande = infos_bande$BANDE
    nbJours = time_length(interval(start = infos_bande$DATE_DEBUT, end = Sys.Date()), unit = "days") 
    query_nb_morts = paste0("select IFNULL(sum(NOMBRE_MORTS), 0) as nb_morts from AVICULTURE.MORTALITE where BANDE = ", infos_bande$BANDE, ";")
    nb_morts_result = dbGetQuery(con, query_nb_morts)
    query_dep = paste0("select IFNULL(sum(COUT), 0) as depenses from AVICULTURE.DEPENSES where BANDE = ", infos_bande$BANDE, ";")
    depenses = dbGetQuery(con, query_dep)
    query_recette = paste0("select IFNULL(sum(PRIX), 0) as recettes from AVICULTURE.VENTES where BANDE = ", infos_bande$BANDE, ";")
    res_recettes = dbGetQuery(con, query_recette)
    query_tab_dep = paste0("select ID, TYPE, COUT, DATE from AVICULTURE.DEPENSES where BANDE = ", infos_bande$BANDE, ";")
    tableau_depenses = dbGetQuery(con, query_tab_dep)
    query_tab_pertes = paste0("select ID, BANDE, NOMBRE_MORTS, DATE from AVICULTURE.MORTALITE where BANDE = ", infos_bande$BANDE, ";")
    tableau_pertes = dbGetQuery(con, query_tab_pertes)
    query_tab_ventes = paste0("select ID, PRIX, NOMBRE_VENDU, DATE from AVICULTURE.VENTES where BANDE = ", infos_bande$BANDE, ";")
    tableau_ventes = dbGetQuery(con, query_tab_ventes)
    thisdepenses = depenses$depenses + infos_bande$PRIX_ACHAT
    nbElements = infos_bande$NOMBRE - nb_morts_result$nb_morts
    prix_revient = (infos_bande$PRIX_ACHAT + depenses$depenses) / nbElements
    recettes = res_recettes$recettes
  }else{
    numBande = 0
    nbJours = 0
    query_nb_morts = 0
    nb_morts_result = 0
    query_dep = 0
    thisdepenses = 0
    nbElements = 0
    prix_revient = 0
    recettes = 0
    tableau_depenses = data.frame(ID=0, BANDE=0, TYPE=0, PRIX=0, NOMBRE_VENDU=0, DATE='')
    tableau_pertes = data.frame(ID=0, BANDE=0, NOMBRE_MORTS=0, DATE='')
    tableau_ventes = data.frame(ID=0, PRIX=0, NOMBRE_VENDU=0, DATE='')
  }
  dbDisconnect(con)
  return(list(numBande = numBande, nbJours=nbJours, nbElements = nbElements, depenses = thisdepenses, recettes=recettes, prix_revient = prix_revient, tableau_depenses=tableau_depenses, tableau_pertes=tableau_pertes, tableau_ventes=tableau_ventes))
  
}

cal_stat_bande1 = function(){
  con <- dbConnect(RMySQL::MySQL(), host = "server.odiagne.com",
                   user = "aviculteur", password = "diagne-avi")
  query_bande1 = 'select * from AVICULTURE.BANDES where BANDE IN (
    select min(BANDE) from AVICULTURE.BANDES where DATE_FIN IS NULL AND DATE_DEBUT IN (
      select min(DATE_DEBUT) from AVICULTURE.BANDES where DATE_FIN IS NULL 
      )
  );'
  infos_bande = dbGetQuery(con, query_bande1)
  summarise_infos(infos_bande, con)
  # if(nrow(infos_bande)>0){
  #   numBande = infos_bande$BANDE
  #   nbJours = time_length(interval(start = infos_bande$DATE_DEBUT, end = Sys.Date()), unit = "days") 
  #   query_nb_morts = paste0("select IFNULL(sum(NOMBRE_MORTS), 0) as nb_morts from AVICULTURE.MORTALITE where BANDE = ", infos_bande$BANDE, ";")
  #   nb_morts_result = dbGetQuery(con, query_nb_morts)
  #   query_dep = paste0("select IFNULL(sum(COUT), 0) as depenses from AVICULTURE.DEPENSES where BANDE = ", infos_bande$BANDE, ";")
  #   depenses = dbGetQuery(con, query_dep)
  #   query_tab_dep = paste0("select ID, TYPE, COUT, DATE from AVICULTURE.DEPENSES where BANDE = ", infos_bande$BANDE, ";")
  #   tableau_depenses = dbGetQuery(con, query_tab_dep)
  #   thisdepenses = depenses$depenses + infos_bande$PRIX_ACHAT
  #   nbElements = infos_bande$NOMBRE - nb_morts_result$nb_morts
  #   prix_revient = (infos_bande$PRIX_ACHAT + depenses$depenses) / nbElements
  # }else{
  #   numBande = 0
  #   nbJours = 0
  #   query_nb_morts = 0
  #   nb_morts_result = 0
  #   query_dep = 0
  #   thisdepenses = 0
  #   nbElements = 0
  #   prix_revient = 0
  #   tableau_depenses = data.frame(ID=0, BANDE=0, TYPE=0, PRIX=0, NOMBRE_VENDU=0, DATE='', REMARQUES='')
  # }
  # dbDisconnect(con)
  # return(list(numBande = numBande, nbJours=nbJours, nbElements = nbElements, depenses = thisdepenses, prix_revient = prix_revient, tableau_depenses=tableau_depenses))
}

cal_stat_bande2 = function(){
  con <- dbConnect(RMySQL::MySQL(), host = "server.odiagne.com",
                   user = "aviculteur", password = "diagne-avi")
  query_bande2 = 'select * from AVICULTURE.BANDES where BANDE IN (
    select min(BANDE) from AVICULTURE.BANDES where DATE_FIN IS NULL AND DATE_DEBUT IN (
      select min(DATE_DEBUT) from AVICULTURE.BANDES where DATE_FIN IS NULL AND DATE_DEBUT > (
          select min(DATE_DEBUT) from AVICULTURE.BANDES where DATE_FIN IS NULL
      )
    )
  );'
  infos_bande = dbGetQuery(con, query_bande2)
  summarise_infos(infos_bande, con)
  # if(nrow(infos_bande)>0){
  #   numBande = infos_bande$BANDE
  #   nbJours = time_length(interval(start = infos_bande$DATE_DEBUT, end = Sys.Date()), unit = "days") 
  #   query_nb_morts = paste0("select IFNULL(sum(NOMBRE_MORTS), 0) as nb_morts from AVICULTURE.MORTALITE where BANDE = ", infos_bande$BANDE, ";")
  #   nb_morts_result = dbGetQuery(con, query_nb_morts)
  #   query_dep = paste0("select IFNULL(sum(COUT), 0) as depenses from AVICULTURE.DEPENSES where BANDE = ", infos_bande$BANDE, ";")
  #   depenses = dbGetQuery(con, query_dep)
  #   thisdepenses = depenses$depenses
  #   nbElements = infos_bande$NOMBRE - nb_morts_result$nb_morts
  #   prix_revient = (infos_bande$PRIX_ACHAT + depenses$depenses) / nbElements
  # }else{
  #   numBande = 0
  #   nbJours = 0
  #   query_nb_morts = 0
  #   nb_morts_result = 0
  #   query_dep = 0
  #   thisdepenses = 0
  #   nbElements = 0
  #   prix_revient = 0
  # }
  # dbDisconnect(con)
  # return(list(numBande = numBande, nbJours=nbJours, nbElements = nbElements, depenses = thisdepenses, prix_revient = prix_revient))
}

cal_stat_bande3 = function(){
  con <- dbConnect(RMySQL::MySQL(), host = "server.odiagne.com",
                   user = "aviculteur", password = "diagne-avi")
  query_bande3 = 'select * from AVICULTURE.BANDES where BANDE IN (
    select min(BANDE) from AVICULTURE.BANDES where DATE_FIN IS NULL AND DATE_DEBUT IN (
  select min(DATE_DEBUT) from AVICULTURE.BANDES where DATE_FIN IS NULL AND DATE_DEBUT > (
  select min(DATE_DEBUT) from AVICULTURE.BANDES where DATE_FIN IS NULL AND DATE_DEBUT > (
  select min(DATE_DEBUT) from AVICULTURE.BANDES where DATE_FIN IS NULL
  )
  )
  )
  )'
  infos_bande = dbGetQuery(con, query_bande3)
  summarise_infos(infos_bande, con)
  # if(nrow(infos_bande)>0){
  #   numBande = infos_bande$BANDE
  #   nbJours = time_length(interval(start = infos_bande$DATE_DEBUT, end = Sys.Date()), unit = "days") 
  #   query_nb_morts = paste0("select IFNULL(sum(NOMBRE_MORTS), 0) as nb_morts from AVICULTURE.MORTALITE where BANDE = ", infos_bande$BANDE, ";")
  #   nb_morts_result = dbGetQuery(con, query_nb_morts)
  #   query_dep = paste0("select IFNULL(sum(COUT), 0) as depenses from AVICULTURE.DEPENSES where BANDE = ", infos_bande$BANDE, ";")
  #   depenses = dbGetQuery(con, query_dep)
  #   thisdepenses = depenses$depenses
  #   nbElements = infos_bande$NOMBRE - nb_morts_result$nb_morts
  #   prix_revient = (infos_bande$PRIX_ACHAT + depenses$depenses) / nbElements
  # }else{
  #   numBande = 0
  #   nbJours = 0
  #   query_nb_morts = 0
  #   nb_morts_result = 0
  #   query_dep = 0
  #   thisdepenses = 0
  #   nbElements = 0
  #   prix_revient = 0
  # }
  # dbDisconnect(con)
  # return(list(numBande = numBande, nbJours=nbJours, nbElements = nbElements, depenses = thisdepenses, prix_revient = prix_revient))
}

eff_bande <- function(stat_bande, bande){
  if(bande == 1){
    colorb = 'light-blue'
  }else if(bande == 2){
    colorb = 'purple'
  }else if(bande == 3){
    colorb = 'olive'
  }
  
  renderValueBox({
    valueBox(
      value = stat_bande$nbElements,
      subtitle = h4(paste0("Éléments de bande ", bande)),
      color = colorb
    )
  })
}

nbJoursBande <- function(stat_bande, bande){
  if(bande == 1){
    colorb = 'light-blue'
  }else if(bande == 2){
    colorb = 'purple'
  }else if(bande == 3){
    colorb = 'olive'
  }
  renderValueBox({
    valueBox(
      value = stat_bande$nbJours,
      subtitle = h4(paste0("Jours pour la bande ", bande)),
      color =colorb
    )
  })
}

depBande <- function(stat_bande, bande){
  if(bande == 1){
    colorb = 'light-blue'
  }else if(bande == 2){
    colorb = 'purple'
  }else if(bande == 3){
    colorb = 'olive'
  }
  renderValueBox({
    valueBox(
      value = stat_bande$depenses,
      subtitle = h4(paste0("F CFA de charges variables en bande ", bande)),
      color =colorb
    )
  })
}

prevBande <- function(stat_bande, bande){
  if(bande == 1){
    colorb = 'light-blue'
  }else if(bande == 2){
    colorb = 'purple'
  }else if(bande == 3){
    colorb = 'olive'
  }
  renderValueBox({
    valueBox(
      value = ceiling(stat_bande$prix_revient),
      subtitle = h4(paste0("Prix de revient unitaire bande ", bande)),
      color =colorb
    )
  })
}

recBande <- function(stat_bande, bande){
  if(bande == 1){
    colorb = 'light-blue'
  }else if(bande == 2){
    colorb = 'purple'
  }else if(bande == 3){
    colorb = 'olive'
  }
  renderValueBox({
    valueBox(
      value = ceiling(stat_bande$recette),
      subtitle = h4(paste0("Recettes de la bande ", bande)),
      color =colorb
    )
  })
}

summaryUpdate = function(output){
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
}

listeDepUpdate = function(input, output){
  stat_bande1 = cal_stat_bande1()
  stat_bande2 = cal_stat_bande2()
  stat_bande3 = cal_stat_bande3()
  
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
}


listePerteUpdate = function(input, output){
  stat_bande1 = cal_stat_bande1()
  stat_bande2 = cal_stat_bande2()
  stat_bande3 = cal_stat_bande3()
  
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
}

listeVenteUpdate = function(input, output){
  stat_bande1 = cal_stat_bande1()
  stat_bande2 = cal_stat_bande2()
  stat_bande3 = cal_stat_bande3()
  
  venteToShow = input$selTabPerte
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
}
