# Layer 1-Network
This repo is part of a multi-part guide that shows how to configure and deploy Compute Engine through a single project described in [This Introduction Topic](../readme.md)

| Step               | Description                                                                                        |
|--------------------|----------------------------------------------------------------------------------------------------|
| [0-init](../0-init/readme.md)             | Project Creation, Service account binding, and API enablement.                                       |
| 1-network-layer (this file)   | Creation of VPC, Subnet, firewall rules, Cloud NAT, and Cloud DNS.                                   |
| [2-compute-deploy](../2-compute-deploy/readme.md)   | Deployment of standalone Compute engine, installation of Nginx script, and configuration of IAP.    |
| [3-mig-deploy](../3-mig-deploy/readme.md)       | Deployment of Managed Instances across 3 regions and setup of Global External HTTPS Load balancer.  |

## Purpose 
The purpose of this step is to deploy Networking Layer, composed of 1 VPC, 3 Subnets, 3 CloudNAT, CLoudDNS implementation and firewall rules configuration. 


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
cd 1-network-layer

export backend_bucket=$(terraform -chdir="../0-init/" output -raw gcs_bucket_tfstate)
echo "remote_state_bucket = ${backend_bucket}"

cp backend.tf.example backend.tf
cp terraform.tfvars.example terraform.tfvars

sed -i '' -e "s/UPDATE_ME/${backend_bucket}/" backend.tf
sed -i '' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" terraform.tfvars
```

2. Configure the terraform.tfvars file to specify VPC-name
```bash
vpc_name            = "CHANGE_ME" # example demo-vpc

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


> [!WARNING]  
> Ensure that previous step have been removed before destroying the network layer 
> Layers which have to be destroyed first : 
> - 2-compute-deploy
> - 3-mig-deploy


To destroy the configuration, initiate through this command : 

```bash
terraform destroy
```

## Input
| Name                | Description                                                             | Type       | Default                  | Required |
|---------------------|-------------------------------------------------------------------------|------------|--------------------------|----------|
| remote_state_bucket | Backend bucket to load Terraform Remote State Data from previous steps. | `string`   | n/a                      | yes      |
| dns_name            | name of dns zone created                                                | `string`   | `"private.exemple.com."` | no       |
| subnet_prefix       | Name prefix to use for subnet                                           | `string`   | `"sb"`                   | no       |
| vpc_prefix          | Name prefix to use for vpc                                              | `string`   | `"vpc"`                  | no       |
| serverless_prefix   | Name prefix to use for serverless                                       | `string`   | `"sac"`                  | no       |
| firewall_prefix     | Name prefix to use for firewall                                         | `string`   | `"fw"`                   | no       |
| peering_prefix      | Name prefix to use for VPC Peering                                      | `string`   | `"np"`                   | no       |
| default_region      | Default region to create resources where applicable.                    | no         |                          |          |
| vpc_name            | VPC name created                                                        | `"string"` | "default"                | no       |
| cloud_router_prefix | Name prefix to use for Cloud router                                     | `string`   | `"cr"`                   | no       |
| cloud_nat_prefix    | Name prefix to use for Cloud NAT server                                 | `string`   | `"cn"`                   | no       |



## Output

| Name       | Description              |
|------------|--------------------------|
| vpc_subnet | List of subnets deployed |
| vpc_name   | Name of VPC created      |
