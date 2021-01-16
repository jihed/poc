# Lambda with API-GW v2

## Create Terraform backend like

```hcl
terraform {
  backend "s3" {
    bucket = "tfstate-bucket-poc-000"
    key    = "lambda/tf.state"
    region = "eu-west-1"
  }
}
```

With Versioning is **ON**

Then clone the repos and run terraform in poc folder.

```bash
terraform init 
terraform plan
terraform apply -auto-approve 
```
