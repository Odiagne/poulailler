FROM rocker/shiny

# Set the working directory to /water_heater
RUN apt-get update -y && apt-get install -y libssl-dev unixodbc-dev libmariadbclient-dev libmariadb-client-lgpl-dev
# Copy the current directory contents into the container at /app
RUN R -e "install.packages(c('httr', 'shiny', 'plotly', 'RMySQL', 'jsonlite', 'DT', 'shinydashboard', 'readxl', 'dplyr', 'lubridate', 'shinyalert', 'shinySignals'), repos='https://cran.rstudio.com/')"
COPY ./dashboard /srv/shiny-server/dashboard
COPY ./gestion /srv/shiny-server/gestion

COPY shiny-server.conf /etc/shiny-server/
COPY shiny-server.sh /usr/bin/shiny-server.sh
# RUN cat /srv/shiny-server/index.html
COPY index.html /srv/shiny-server/index.html
#COPY logo.png /srv/shiny-server/logo.png
RUN ["chmod", "+x", "/usr/bin/shiny-server.sh"]
CMD ["/usr/bin/shiny-server.sh"]


EXPOSE 3838
