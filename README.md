# Lambda with API-GW v2

This is a POC to create a lambda function using docker image (NodeJS): image will be build with docker provider and then pushed to ECR.

Currently, there's an issue with lambda persmission: <https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/97>

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

More to come !

## NodeJS

FYI:

```bash
npm init
npm install pdfkit
npm install faker
npm install get-stream
````
