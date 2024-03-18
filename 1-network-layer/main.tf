locals {
  default_region  = data.terraform_remote_state.init.outputs.common_config.default_region
  project_init_id = data.terraform_remote_state.init.outputs.seed_project_id
  env             = "demo"
}


data "terraform_remote_state" "init" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/init/state"
  }
}

