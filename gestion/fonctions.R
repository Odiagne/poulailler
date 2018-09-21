require(RMySQL)
add_bande = function(date_debut, nombre, prix_achat){
  con <- dbConnect(RMySQL::MySQL(), host = "server.odiagne.com",
                   user = "aviculteur", password = "diagne_avi")
  
  query = paste0('INSERT INTO AVICULTURE.BANDES(DATE_DEBUT, NOMBRE, PRIX_ACHAT) VALUES("', date_debut, '", ', nombre, ', ', prix_achat,")") 
  dbGetQuery(con, query)
  dbDisconnect(con)
}

add_depense = function(bande, type, cout, date){
  con <- dbConnect(RMySQL::MySQL(), host = "server.odiagne.com",
                   user = "aviculteur", password = "diagne_avi")
  
  query = paste0('INSERT INTO AVICULTURE.DEPENSES(BANDE, TYPE, COUT, DATE) VALUES(', bande, ', "', type, '", ', cout, ', "', date, '")') 
  dbGetQuery(con, query)
  dbDisconnect(con)

}
