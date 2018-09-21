require(RMySQL)
require(lubridate)
add_bande = function(date_debut, nombre, prix_achat){
  con <- dbConnect(RMySQL::MySQL(), host = "server.odiagne.com",
                   user = "aviculteur", password = "diagne_avi")
  
  query = paste0('INSERT INTO AVICULTURE.BANDES(DATE_DEBUT, NOMBRE, PRIX_ACHAT) VALUES("', date_debut, '", ', nombre, ', ', prix_achat,")") 
  dbGetQuery(con, query)
  dbDisconnect(con)
}

add_depense = function(bande, type, cout, date, remarque){
  con <- dbConnect(RMySQL::MySQL(), host = "server.odiagne.com",
                   user = "aviculteur", password = "diagne_avi")
  
  query = paste0('INSERT INTO AVICULTURE.DEPENSES(BANDE, TYPE, COUT, DATE, REMARQUES) VALUES(', bande, ', "', type, '", ', cout, ', "', date, '", "', remarque,'")') 
  dbGetQuery(con, query)
  dbDisconnect(con)

}

add_mort = function(bande, nb_morts, date, remarque){
  con <- dbConnect(RMySQL::MySQL(), host = "server.odiagne.com",
                   user = "aviculteur", password = "diagne_avi")
  
  query = paste0('INSERT INTO AVICULTURE.MORTALITE(BANDE, NOMBRE_MORTS, DATE, REMARQUES) VALUES(', bande, ', ', nb_morts, ', "', date, '", "', remarque, '")') 
  dbGetQuery(con, query)
  dbDisconnect(con)
}

cal_stat_bande1 = function(){
  con <- dbConnect(RMySQL::MySQL(), host = "server.odiagne.com",
                   user = "aviculteur", password = "diagne_avi")
  query_bande1 = 'select * from AVICULTURE.BANDES where BANDE IN (
    select min(BANDE) from AVICULTURE.BANDES where DATE_DEBUT IN (
      select min(DATE_DEBUT) from AVICULTURE.BANDES)
  );'
  infos_bande = dbGetQuery(con, query_bande1)
  nbJours = time_length(interval(start = infos_bande$DATE_DEBUT, end = Sys.Date()), unit = "days") 
  query_nb_morts = paste0("select IFNULL(sum(NOMBRE_MORTS), 0) as nb_morts from AVICULTURE.MORTALITE where BANDE = ", infos_bande$BANDE, ";")
  nb_morts_result = dbGetQuery(con, query_nb_morts)
  query_dep = paste0("select IFNULL(sum(COUT), 0) as depenses from AVICULTURE.DEPENSES where BANDE = ", infos_bande$BANDE, ";")
  depenses = dbGetQuery(con, query_dep)
  prix_revient = (infos_bande$PRIX_ACHAT + depenses$depenses) / infos_bande$NOMBRE
  dbDisconnect(con)
  return(list(numBande = infos_bande$BANDE, nbJours=nbJours, nbElements = infos_bande$NOMBRE - nb_morts_result$nb_morts, depenses = depenses$depenses, prix_revient = prix_revient))
}
