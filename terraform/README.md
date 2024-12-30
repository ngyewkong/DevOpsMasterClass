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

- Setting up AWS to use Terraform

  - Create IAM Admin User with all the necessary permissions
  - Manage Security between Machine with Terraform and AWS
    - create a IAM user and user group for admin access for terraform
    - create a Security Group for EC2 and add the machine with terraform running IP address to whitelist
  - will need to run terraform init if change working dir
  - terraform plan -out somePlan.out to review
    - Terraform will perform the following actions: aws_instance.vm-created-using-terraform will be created
  - terraform apply to apply the createAWSInstance.tf in AWS
    - can also run terraform apply "somePlan.out"
    - need type yes to continue the deployment
    - Creation complete after 17s (i-0e26c218cfdb7c65b) -> match with the created ec2
    - Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
  - terraform destroy (will delete the deployment)
    - Destroy complete! Resources: 1 destroyed.

- Using env variables to pass in credentials to terraform

  - need to use export & take note the key name is important
    - export AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY"
    - env | grep -i aws (to show the respective env variables for aws)

- use tags to set the name in the aws ec2 instances

  - to set the dynamically the names of the instances (instead of static same names)
    - Name = "terraform-demo-instances-${count.index}"

- Resource Tracking using Terraform State files

  - changes made using terraform will be saved to the terraform state file (terraform.tfstate)
  - stored as a flat file & stored in the same working directory but can be stored remotely
  - helps terraform calculate deployment deltas.
  - terraform plan can be used to created the new deployment plan
  - if terraform state files is lost, have to do manually for creation, update or deletion of resources
  - will contain all the metadata for the instances created by terraform
  - after terraform destroy (the metadata part are deleted)

- Variables in Terraform

  - to parameterise the deployments using Terraform
  - terraform input variables
    - defined using a variable block inside the .tf file
    - common location used is variables.tf
    - eg of declaration of variable
      - variable "varName" {
      - type = string
      - default = "eastus"
      - }
    - conditional input variables
      - can have custom validation rules for an input variable by using a validation block
  - will need a provider.tf (for the aws provider plugin), a variables.tf (to declare terraform input variables)
    - this will prompt for variables without default set
    - or running terraform plan -var AWS_ACCESS_KEY="YOUR_ACCES_KEY" -var AWS_SECRET_KEY="YOUR_SECRET_KEY"
    - or add a terraform.tfvars file to define the variables and its values or terraform apply -var-file="somefile.tfvars"

- List and Map variables in Terraform

  - list(another_type) need to be declared in variables.tf
  - terraform plan -> will see the three security groups being added (but the security groups must be valid if not will fail)
  - map(another_type) need to be declared in variables.tf
  - terraform plan -> default take us-east-2 and give ami-05803413c51f242b7
  - terraform plan -var AWS_REGION="us-west-1" -> give ami-0454207e5367abf01

- Provision Software with Terraform

  - using custom image or ami
  - Terraform Provisioner need to use SSH (Unix/Linux) or WinRM (windows)
  - AWS needs to use SSH KeyPairs
  - remote-exec to execute the script
  - ssh-keygen to create the Public & Private keys
    - execute ssh-keygen -f secretKeyName

- Datasources in Terraform

  - to retrieve aws parameters during runtime (dynamic vs static hardcode values)
  - keyword data
    - data "PROVIDER_PREDEFINED_FIELD" "Name_of_Data_for_reference"
    - eg. data "aws_security_group" "myNewSG"

- Output Attribute in Terraform

  - outputs in tf can be queried & retained
    - retain private IP addresses for further workflow
  - child module can use outputs to expose a subset of its resource attributes to a parent module
  - root module can use outputs to print certain values in the cli after executing terraform apply
  - output value exported must be declared in an output block
  - output "instance_ip_addr" {value = aws_instance_server.private_ip}
  - output is only rendered when terraform apply is executed (terraform plan will not render output)
  - outputs can also be used in scripts (local-exec or remote-exec provisioner)

- Remote State in Terraform
  - tf records information abt what infra it created in a terraform state file
    - terraform.tfstate file
    - terraform.tfstate.backup is the backup of the earlier statefile
  - when "terraform apply" is executed -> backup is written and new state file is created
  - complications with tfstate file
    - if user goes to remove infra on the aws console without using terraform
    - terraform will maintain the remote state (terraform apply -> will recreate the infra)
    - users will need access to the same tfstate files to use terraform to update infra
      - tfstate files will need to be in the shared location
    - locking tfstate files
      - without locking, when two team members are running terraform at the same time
      - will run into race conditions as multiple tf processes make concurrent updates to the tfstate files
      - resulting in conflicts, data loss or state file corruption
    - isolating state files
      - make sure the files of each env (pre-prod & prod) should be isolated
      - so that file of pre-prod will not be used to run on prod env which will change the configuration of the prod env
  - solutions to combat the three cons
    - use version control system like git
      - manual error due to lack of git pull
      - no locking
      - all data in tfstate files are stored in plain text (sensitive data will be on vcs once committed)
    - use terraform built in remote backends
      - once configured, terraform will auto load the state file from the backend everytime when plan or apply is executed and store the tfstate file in that backend after each apply
      - remote backends natively support locking
      - remote backends natively support encryption in transit and on disk
      - eg store tfstate in aws s3 as remote backend
      - terraform {backend "s3"}
      - when using s3 as the remote backend -> rec to use aws configure instead of aws creds in variables to configure the key
      - create s3 bucket to use as the remote backend & enable versioning
      - aws configure requires aws cli
        - sudo apt-get update
        - sudo apt-get install aws-cli
