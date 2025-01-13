# Used to fetch the outputs from devopsutils statefile
data "terraform_remote_state" "devopsutils" {
  backend = "azurerm"

  config = {
    use_oidc             = true
    storage_account_name = "stglbuksdevopstf"
    container_name       = "devopsutils"
    key                  = "devops.tfstate"
  }
}