/* define backend as local file */
terraform {
    backend "local" {
        path = "/opt/buckets/rauflint/terraform.tfstate"
    }   
}