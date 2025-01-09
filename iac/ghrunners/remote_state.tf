# Used to fetch the outputs from devopsutils statefile
data "terraform_remote_state" "devopsutils" {
  backend = "azurerm"

  config = {
    storage_account_name = "stglbuksdevopstf"
    container_name       = "devopsutils"
    key                  = "devops.tfstate"
  }
}