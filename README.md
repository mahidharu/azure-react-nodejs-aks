# azure-reactjs-nodejs-aks
Sample React app to deploy it onto an Azure Kubernetes cluster using TerraForm and Azure Pipelines

# Prerequisites:
1) React App
2) Dockerfile
3) Install Azure CLI and Terraform tools
4) Azure Login
5) Set Azure Subscription
6) Set Role based access
    - In this step, where you will be need to capture the App ID, other details

# Step: 1 - To initilize the terraform configurations
terraform init

# Step: 2 - To apply the changes
terraform apply

# Step: 3 - To destroy the configurations
terraform destroy
