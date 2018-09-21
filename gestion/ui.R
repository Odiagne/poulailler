
options(encoding = "UTF-8")
require(shinydashboard)
require(plotly)
#require(shinySignals)
dashboardPage(
  dashboardHeader(title = "DIAGNE-avi"),
  dashboardSidebar(
    # sliderInput("rateThreshold", "Warn when rate exceeds",
    #             min = 0, max = 50, value = 3, step = 0.1
    # ),
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard"),
      menuItem("Dépenses", tabName = "depenses"),
      menuItem("Mortalité", tabName = "mortalite"),
      menuItem("Bandes", tabName = "bandes")
      # ,
      # menuItem("Map", tabName = "map")
    )
  )
,
  dashboardBody(
    tabItems(
      tabItem("dashboard",
              fluidRow(
                valueBoxOutput("effBande1"),
                valueBoxOutput("effBande2"),
                valueBoxOutput("effBande3")
              ),
              fluidRow(
                  valueBoxOutput("depBande1"),
                  valueBoxOutput("depBande2"),
                  valueBoxOutput("depBande3")
                # ,
                # box(
                #   width = 4, status = "info", solidHeader = TRUE,
                #   title = "Répartition de l'autoconsommation",
                #   plotlyOutput('rep_autoconso')
                # ),
                # box(
                #   width = 4, status = "info", solidHeader = TRUE,
                #   title = "Répartition de l'autonomie",
                #   plotlyOutput('rep_autonomie')
                # )
              ),
              fluidRow(
                valueBoxOutput("prevBande1"),
                valueBoxOutput("prevBande2"),
                valueBoxOutput("prevBande3")
              )
      )
      ,
      tabItem("depenses",
              fluidRow(
                box(
                  width = 6, status = "info", solidHeader = TRUE,
                  title = "Ajouter une dépense",
                  numericInput("numBandeDep", label = h4("Entrez le numéro de la bande"), value = NA, min = 0),
                  textInput("typeDepense", label = h4("Entrez le type de dépense")),
                  numericInput("coutDep", label = h4("Entrez le cout de la dépense"), value = NA, min = 0),
                  dateInput("dateDepense", label = h4('Date de la dépense'), value = Sys.Date()),
                  textInput("remarques", label = "Remarques ?"),
                  actionButton("validerDepense", "Valider")
                  
                )
              )
              # ,
              # tabItem("rawdata",
              #         numericInput("byPower", "Rows to show", 25)
              #         #,
              #         # verbatimTextOutput("rawtable"),
              #         # downloadButton("downloadCsv", "Download as CSV")
              # )
      )
      ,
      tabItem("mortalite",
              fluidRow(
                box(
                  width = 6, status = "info", solidHeader = TRUE,
                  title = "Recenser les morts",
                  numericInput("numBandeMort", label = h4("Entrez le numéro de la bande"), value = NA, min = 0),
                  numericInput("nbMort", label = h4("Entrez le nombre de morts"), value = NA, min = 0),
                  dateInput("dateMort", label = h4('Date du constat'), value = Sys.Date()),
                  textInput("remarquesMort", label = "Remarques ?"),
                  actionButton("validerMortalite", "Valider")
                  
                )
              )
              # ,
              # tabItem("rawdata",
              #         numericInput("byPower", "Rows to show", 25)
              #         #,
              #         # verbatimTextOutput("rawtable"),
              #         # downloadButton("downloadCsv", "Download as CSV")
              # )
      )
      ,
      tabItem("bandes",
              fluidRow(
                box(
                  width = 6, status = "info", solidHeader = TRUE,
                  title = "Ajouter une bande",
                  dateInput("dateDebutBande", label = h4('Date de début'), value = Sys.Date()),
                  numericInput("nombreElementsBande", label = h4("Entrez le nombre d'éléments"), value = NA, min = 0),
                  numericInput("prixAchat", label = h4("Entrez le prix d'achat de la bande"), value = NA, min = 0),
                  actionButton("validerDebutBande", "Valider")
                  
                  # ,
                  # tableOutput("packageTable")
                ),
                box(
                  width = 6, status = "info", solidHeader = TRUE,
                  title = "Cloturer une bande",
                  numericInput("numBandeCloture", label = h4("Entrez le numéro de la bande"), value = NA, min = 0),
                  dateInput("dateFinBande", label = h4('Date de fin'), value = Sys.Date()),
                  textInput("remarques", label = "Remarques ?"),
                  actionButton("validerFinBande", "Valider")
                  
                )
              )
      )
      #   ,
      #   tabItem("map",
      #     fluidRow(
      #       selectInput("selKPI", label = h4("Selectionnez la valeur Ã  afficher"), 
      #                   choices = list("autoconsommation" = "autoconsommation",
      #                                  "autonomie" = "autonomie",
      #                                  "productible" = "productible",
      #                                  "puissance installee" = "puissanceInstallee")),
      #         tags$script(src="https://d3js.org/d3.v5.min.js"),
      #         tags$script(src="test.js"),
      #         tags$div(id="mapChart")
      #     # box(
      #     #   width = 6, status = "info",
      #     #   title = "Valorisation financiÃ¨re par kWh",
      #     #   plotlyOutput('valfinUnitaire')
      #     #   # ,
      #     #   # tableOutput("packageTable")
      #     # )
      #   )
      # )
    )
  )
)
