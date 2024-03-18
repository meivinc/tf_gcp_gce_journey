# Layer 2-Compute standalone
This repo is part of a multi-part guide that shows how to configure and deploy Compute Engine through a single project described in [This Introduction Topic](../readme.md)

| Step               | Description                                                                                        |
|--------------------|----------------------------------------------------------------------------------------------------|
| [0-init](../0-init/readme.md)              | Project Creation, Service account binding, and API enablement.                                       |
| [1-network-layer](../1-network-layer/readme.md)    | Creation of VPC, Subnet, firewall rules, Cloud NAT, and Cloud DNS.                                   |
| 2-compute-deploy (this file)  | Deployment of standalone Compute engine, installation of Nginx script, and configuration of IAP.    |
| [3-mig-deploy](../3-mig-deploy/readme.md)       | Deployment of Managed Instances across 3 regions and setup of Global External HTTPS Load balancer.  |

## Purpose 
The purpose of this step is to deploy 3 Compute Engine on 3 different region. Each Instance is reachable thorugh SSH and have access to Ubuntu Repository. 

## Prerequisites

> [!IMPORTANT]  
> Ensure you're authenticated with the impersonnation service Account 
> 
> Command reminder : 
> ```bash
> #From root folder
>   export layer_step=$(terraform -chdir="./0-init" output -raw init_step_terraform_service_account_email)
>   echo "network step service account = ${layer_step}"
>   gcloud config set auth/impersonate_service_account $layer_step
>   gcloud auth application-default login --impersonate-service-account $layer_step
> ```


## Usage 

1. Retrieve backend information from previous step 

```bash
cd 2-compute-deploy

export backend_bucket=$(terraform -chdir="../0-init/" output -raw gcs_bucket_tfstate)
echo "remote_state_bucket = ${backend_bucket}"

cp backend.tf.example backend.tf
cp terraform.tfvars.example terraform.tfvars

sed -i '' -e "s/UPDATE_ME/${backend_bucket}/" backend.tf
sed -i '' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" terraform.tfvars
```

2. Configure the terraform.tfvars file to specify IAP allowed group or user
```bash
user_to_iap = "user:user@domain.com" # User or group possible

```

3. Init and plan terraform configuration to ensure everything is ok

```bash
terraform init
terraform plan
```


4. Apply configuration 

```bash
terraform apply
```


## Destroy 

To destroy the configuration, initiate through this command : 

```bash
terraform destroy
```

## Input 

| Name                | Description                                                             | Type       | Default | Required |
|---------------------|-------------------------------------------------------------------------|------------|---------|----------|
| remote_state_bucket | Backend bucket to load Terraform Remote State Data from previous steps. | `string`   | n/a     | yes      |
| user_to_iam         | User or Groups created by default                                       | `"string"` | null    | yes      |
| gce_prefix          | Prefix related to compute engine                                        | `"string"` | `"ins"` | no       |



## Output 
N/A