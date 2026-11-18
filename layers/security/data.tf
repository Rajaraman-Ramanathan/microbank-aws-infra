data "terraform_remote_state" "dns" {
  backend = "local"

  config = {
    path = "../dns/terraform.tfstate"
  }
}