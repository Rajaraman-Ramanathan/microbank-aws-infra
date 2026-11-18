data "terraform_remote_state" "iam" {
  backend = "local"

  config = {
    path = "../iam/terraform.tfstate"
  }
}

data "terraform_remote_state" "dns" {
  backend = "local"

  config = {
    path = "../dns/terraform.tfstate"
  }
}