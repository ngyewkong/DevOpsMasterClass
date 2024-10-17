# Terraform

- IAC (Infrastructure As Code)

  - less manual intervention, less error prone
  - supports multiple cloud providers (eg AWS, Azure, GCP, Oracle, Alibaba)
  - Deploy Env across multiple clouds

- Terraform Workflow

  - 1. Write Terraform Config
    - start with creating HashiCorp Configuration Language (HCL) config file for Infra
  - 2. Plan Infrastructure
    - Review Infra
  - 3. Deploy Infrastructure
    - Apply and deploy the Infrastructure

- Terraform Commands

  - terraform init: Command to initialize the working dir that contains the IAC
    - will download the supporting component/s (modules and plugins)
      - https://registry.terraform.io/providers/hashicorp/aws/latest/docs (for aws provider doc)
    - setup backend to store terraform state files
  - terraform plan: Command to read the code and then create and show the planned deployment
    - allow user to review the plan before execution
    - authentication credentials are used to connect to the infrastructure at this point
  - terraform apply: actual deployment of the infrastructure
    - update the deployment state files
    - if existing resources are already deployed -> command will deploy updated IAC and tracking
  - terraform destroy: look at the terraform state files and destroy all resources found in the state files
    - non-reversible command -> make sure to backup before destroy
