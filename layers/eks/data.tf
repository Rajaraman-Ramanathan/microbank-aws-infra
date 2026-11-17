data "terraform_remote_state" "network" {
  backend = "local"

  config = {
    path = "../network/terraform.tfstate"
  }
}

data "terraform_remote_state" "iam" {
  backend = "local"

  config = {
    path = "../iam/terraform.tfstate"
  }
}

data "terraform_remote_state" "kms" {
  backend = "local"

  config = {
    path = "../kms/terraform.tfstate"
  }
}