cleanup <- function() {
system("rm -rf ~/R ~/.cache ~/.config ~/.Rprofile .Rprofile rsconnect renv")
rstudioapi::restartSession()
}

envset <- function() {
  Sys.setenv("CONNECT_USER"="mmayer")
  Sys.setenv("CONNECT_USER_KEY"="SGlhHT0KQ1Qvc4JRNIlbpv3kcoZCdSjW")
  Sys.setenv("CONNECT_SERVER"="http://192.168.0.100:3939")
  
}

connectsetup <- function() {
  rsconnect::addConnectServer(Sys.getenv("CONNECT_SERVER"), name="Connect")
  rsconnect::connectApiUser(account=Sys.getenv("CONNECT_USER"),apiKey = Sys.getenv("CONNECT_USER_KEY"))
}

envset()
connectsetup()

rsconnect::deployApp(appDir="shiny")

cleanup()