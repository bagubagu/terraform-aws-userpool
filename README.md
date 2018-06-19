# Terraform AWS Userpool

Create userpool and related resources.

## How to use

1.  create a `infra/main.tf` in your project root directory. Replace the `aws.profile` and `userpool.hosted_zone`. Also `userpool.google_client{id,secret}`

    ```terraform
    # main.tf

    provider "aws" {
        region  = "us-east-1"
        profile = "exampleAdmin"
    }

    module "userpool" {
        source        = "github.com/bagubagu/terraform-aws-userpool"
        hosted_zone   = "example.com"
        force_destroy = true
        google_client_id = "xxx"
        google_client_secret = "xxx"
    }
    ```

1.  Init and run terraform apply from the `infra` directory

    ```bash
    cd infra
    terraform init
    terraform apply
    ```

1.  C'est la vie!

## What does this do?

If hosted_zone is `example_com`:

- ...
- ...
