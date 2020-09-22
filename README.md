# cloud-platform-terraform-monitoring

Terraform module that deploy cloud-platform pushgateway solution.

## Overview

Pushgateway is an intermediary service which allows you to define and push 'custom' metrics from jobs. Usually these would be metrics from instances or external components
that reside outside of the kubernetes cluster and so by default Prometheus would not be able to scrape the metrics. 

Pushgateway therefore acts as the intermediary between the metric source and Promethues

Metrics are 'pushed' to Pushgateway as opposed to the 'pull' model of Prometheus

Once a metrics are 'pushed' to the Pushgateway service, Prometheus can scrape the metrics by adding a Pushgateway 'target' to its configuration

The ```prometheus-operator``` used to install the existing monitoring stack (Prometheus, Grafana etc) does not currently have any CRDs of ```kind: PushGateway```.
The Pushgateway therefore needs to be installed independently of the monitoring stack.

This module uses terraform's ```helm_release``` resource to deploy the ```stable/prometheus-pushgateway```. More information on this chart can be found here:
https://github.com/helm/charts/tree/master/stable/prometheus-pushgateway

## Usage

```hcl
module "pushgateway" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-pushgateway?ref=1.0.0"
  enable_service_monitor        = true
}
```

To deploy Pushwaygateway, execute the module within your namespace. See ```example/pushgateway``` as a template example

Once deployed you should see the associated resources for Pushgateway 

```kubdectl get all -n <NAMESPACE>```


``` kubectl port-forward service/pushgateway-prometheus-pushgateway 9091 -n monitoring ```


## Inputs

| Name                         | Description         | Type | Default | Required |
|------------------------------|---------------------|:----:|:-------:|:--------:|


## Outputs

| Name | Description |
|------|-------------|


