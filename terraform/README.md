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

- Installing Terraform on MacOS

  - https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
  - brew tap hashicorp/tap
  - brew install hashicorp/tap/terraform
  - terraform version (to check if terraform cli is installed)

- Terraform Providers & Initialization
  - Providers are the cloud vendors (eg. AWS)
  - Providers are plugins used by Terraform to interact with cloud providers
  - Terraform configurations must declare which providers they require
  - Terraform Providers release is separate from Terraform release
  - You can write your own custom providers
  - Once terraform init is executed, Terraform find and install the providers
  - important to specify the provider version in the terraform config file (if not default will take latest version)
  - registry for providers (https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
  - create a terraform config file (main.tf)
  - export TF_LOG=TRACE in console to print all Terraform related logging to the console terminal
  - cd into providers folder which contains the main.tf and run terraform init
  - Terraform has been successfully initialized!
  - You may now begin working with Terraform. Try running "terraform plan" to see any changes that are required for your infrastructure. All Terraform commands should now work.
  - Terraform creates hidden files (.terraform & .terraform.lock.hcl) in the initialized folder
    - .terraform dir contain the plugin for the providers
    - .terraform.lock.hcl shows the providers info
