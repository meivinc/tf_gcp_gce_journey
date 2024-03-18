locals {
  default_region     = data.terraform_remote_state.init.outputs.common_config.default_region
  project_init_id    = data.terraform_remote_state.init.outputs.seed_project_id
  vpc_name           = data.terraform_remote_state.network.outputs.vpc_name
  vpc_subnet         = data.terraform_remote_state.network.outputs.vpc_subnet
  vpc_network_config = data.terraform_remote_state.network.outputs.network_common_config


}


data "terraform_remote_state" "init" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/init/state"
  }
}


data "terraform_remote_state" "network" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/network/state"
  }
}


