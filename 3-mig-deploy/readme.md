# Layer 3-Compute MIG 
This repo is part of a multi-part guide that shows how to configure and deploy Compute Engine through a single project described in [This Introduction Topic](../readme.md)


| Step               | Description                                                                                        |
|--------------------|----------------------------------------------------------------------------------------------------|
| [0-init](../0-init/readme.md)               | Project Creation, Service account binding, and API enablement.                                       |
| [1-network-layer](../1-network-layer/readme.md)    | Creation of VPC, Subnet, firewall rules, Cloud NAT, and Cloud DNS.                                   |
| [2-compute-deploy](../2-compute-deploy/readme.md)   | Deployment of standalone Compute engine, installation of Nginx script, and configuration of IAP.    |
| 3-mig-deploy (this file)      | Deployment of Managed Instances across 3 regions and setup of Global External HTTPS Load balancer.  |

## Purpose 
The purpose of this step is to deploy Three MIG on Three Region attached to a single External HTTPS Load Balancer. 

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
cd 3-mig-deploy

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

> [!NOTE]  
> MIG could take up to 5 minutes to be up & running


5. Test load balancer

```bash
export external_ip=$(terraform output -raw lb_external_ip)
echo "lb external IP = ${external_ip}"

curl http://$external_ip
```

> [!TIP]
> You can see results similar to this : 
> ```bash
> Name: demo-mmxr.europe-west3-b.c.<PROJECT_ID>.internal
> IP: 192.168.1.4
> Metadata: {
>   "created-by": "projects/<PROJECT_ID>/regions/europe-west3/instanceGroupManagers/mig-europe-west3-demo",
>   "enable-oslogin": "true",
>   "google-logging-enabled": "true",
>   "instance-template": "projects/<PROJECT_ID>/global/instanceTemplates/mig-compute-template-europe-west3",
>   "stop-state": "UNSPECIFIED"
> }
> ```
> if you want to try the loadbalance based on geo-location, you can SSH other VM and repeat the curl command. 
> Note : Some FW rules have to be opened ;) 



## Destroy 

To destroy the configuration, initiate through this command : 

```bash
terraform destroy
```



## Input
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|


## Output

| Name           | Description                               |
|----------------|-------------------------------------------|
| lb_external_ip | External IP created through Load Balancer |

