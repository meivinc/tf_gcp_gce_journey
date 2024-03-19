# Layer 0-init
This repo is part of a multi-part guide that shows how to configure and deploy Compute Engine through a single project described in [This Introduction Topic](../readme.md)

| Step               | Description                                                                                        |
|--------------------|----------------------------------------------------------------------------------------------------|
| 0-init (this file)             | Project Creation, Service account binding, and API enablement.                                       |
| [1-network-layer](../1-network-layer/readme.md)    | Creation of VPC, Subnet, firewall rules, Cloud NAT, and Cloud DNS.                                   |
| [2-compute-deploy](../2-compute-deploy/readme.md)   | Deployment of standalone Compute engine, installation of Nginx script, and configuration of IAP.    |
| [3-mig-deploy](../3-mig-deploy/readme.md)       | Deployment of Managed Instances across 3 regions and setup of Global External HTTPS Load balancer.  |


## Purpose 
The purpose of this step is to deploy a Google Cloud Project which will contains the overall content of this Github Repository. 

## Prerequisites
> [!NOTE]  
> To run the commands described in this document, install the following:
> 
> - [Google Cloud SDK](https://cloud.google.com/sdk/install) version 393.0.0 or later
> - [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) version 2.28.0 or later
> - [Terraform](https://www.terraform.io/downloads.html) version 1.3.0


> [!IMPORTANT]  
> Ensure you are executing this code into your Google Cloud environment.
> 
> Ensure you have enough rights to execute this terraform code 
>Also make sure that you've done the following:
>
>Set up a Google Cloud organization.
>Set up a Google Cloud billing account.
>
>For the user who will run the procedures in this document, grant the following roles:
> - The `roles/resourcemanager.projectCreator` role on the Google Cloud organization or folder.
> - The `roles/orgpolicy.policyAdmin` role on the Google Cloud organization.
> - The `roles/billing.admin` role on the billing account.
> - The `roles/resourcemanager.folderCreator` role.
> - The `roles/iam.serviceAccountCreator` role.
>

## Usage 

Clone the Repository:
``` bash
git clone https://github.com/meivinc/tf_gcp_gce_journey.git
cd tf_gcp_gce_journey

# Init your project 
cd 0-init

cp terraform.tfvars.example terraform.tfvars
```

In the folder 0-init, edit terraform file (terraform.tfvars) and replace the following with your informations : 

```bash
org_id = "000000000000" 

billing_account = "000000-000000-000000"

default_region = "gcp-region"

service_account_name = "tf-gce"

project_name = "gce-deploy"

```

authenticate to Google Cloud through gcloud command 
```bash
gcloud auth login 
gcloud auth application-default login 
```

Initialize Terraform and check creation

```bash
terraform init
terraform plan
```

Validate the plan and apply
```bash
terraform apply
```

Copy the backend and update backend.tf with the name of your Google Cloud Storage bucket for Terraform's state. Also update the backend.tf of all steps.

```bash
export backend_bucket=$(terraform output -raw gcs_bucket_tfstate)
echo "backend_bucket = ${backend_bucket}"

cp backend.tf.example backend.tf

sed -i '' -e "s/UPDATE_ME/${backend_bucket}/" backend.tf
```

Migrate Tfstate to Cloud Storage bucket
```bash
terraform init -migrate-state
```

Use service account for next step 

```bash
export layer_step=$(terraform output -raw init_step_terraform_service_account_email)
echo "network step service account = ${layer_step}"

# Impersonate service account 

gcloud config set auth/impersonate_service_account $layer_step
gcloud auth application-default login --impersonate-service-account $layer_step
```

## Destroy the environment 

to destroy 

> [!WARNING]  
> Ensure that previous step have been removed before destroying the network layer 
> Layers which have to be destroyed first : 
> - 3-mig-deploy
> - 2-compute-deploy
> - 1-network-layer


To destroy the configuration, You have to : 
- Remove terraform tfstate and bring it back on local 
- Unset Impersonation Service account
- Destroy terraform configuration

```bash
rm backend.tf

#Migrate Tfstate to Cloud Storage bucket
terraform init -migrate-state

#Unset Service Account impersonation
gcloud config unset auth/impersonate_service_account

#Re authenticate with your account 
gcloud auth login 
gcloud auth application-default login 


# Initiate removal from terraform 
terraform destroy
```


## Input

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
|seed_project_id|Project which handle all the project|`string`|`"prj-gce-lab-<suffix>"`|no|
|gcs_bucket_tfstate|Bucket used to host terraform tfstate|`string`|`"bkt-tfstate-<suffix>"`|no|
|folder_prefix|Name prefix to use for folders created. Should be the same in all steps.|  `string`|`"fldr"`| yes |
|bucket_prefix|Name prefix to use for state bucket created.| `string`|`"bkt"`|no|
|default_region|Default region to create resources where applicable.| `string`|`"us-central1"`|no|
|org_id|GCP Organization ID|`string`|n/a|yes|
|billing_account|The ID of the billing account to associate projects with.|`string`|n/a|yes|
|service_account_name|Service account used to deploy the following steps| `string`|`"tf-gce-lab'`|no|

## Output


| Name                                      | Description                                                       |
|-------------------------------------------|-------------------------------------------------------------------|
| seed_project_id                           | Project Id refering to the whole Github Project                   |
| init_step_terraform_service_account_email | Service Account email dedicated to the deployment of this projecT |
| gcs_bucket_tfstate                        | Name of the bucket deployed to store terraform tfstate            |
| common_config                             | Common configuration data to be used in other steps               |
