# cloud-platform-terraform-monitoring

Terraform module that deploy cloud-platform pushgateway solution.

## Usage

```hcl
module "pushgateway" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-pushgateway?ref=1.0.0"
  enable_service_monitor        = true
}
```

## Inputs

| Name                         | Description         | Type | Default | Required |
|------------------------------|---------------------|:----:|:-------:|:--------:|


## Outputs

| Name | Description |
|------|-------------|


