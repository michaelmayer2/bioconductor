cleanup <- function() {
system("rm -rf ~/R ~/.cache ~/.config ~/.Rprofile .Rprofile rsconnect renv")
rstudioapi::restartSession()
}

connectsetup <- function() {
  rsconnect::addConnectServer(Sys.getenv("CONNECT_SERVER"), name="Connect")
  rsconnect::connectApiUser(account=Sys.getenv("CONNECT_USER"),apiKey = Sys.getenv("CONNECT_USER_KEY"))
}


connectsetup()

rsconnect::deployApp(appDir="shiny")

cleanup()