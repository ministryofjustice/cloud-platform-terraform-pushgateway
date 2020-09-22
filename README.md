# cloud-platform-terraform-monitoring

Terraform module that deploy cloud-platform pushgateway solution.

## Overview

Pushgateway is an intermediary service which allows you to define and push 'custom' metrics from jobs. Usually these would be metrics from instances or external components
that reside outside of the kubernetes cluster and so by default Prometheus would not be able to scrape the metrics. 

Pushgateway therefore acts as the intermediary between the metric source and Promethues

Metrics are 'pushed' to Pushgateway as opposed to the 'pull' model of Prometheus

Once metrics are 'pushed' to the Pushgateway service, then Prometheus can scrape the metrics by adding a Pushgateway 'target' to its configuration

The prometheus-operator used to install the existing monitoring stack (Prometheus, Grafana etc) does not currently have any CRDs of ```kind: PushGateway```.
The Pushgateway therefore needs to be installed independently of the prometheus-operator helm chart and instead installed through its own helm chart.

This module uses terraform's ```helm_release``` resource to deploy the ```stable/prometheus-pushgateway```. More information on this chart can be found here:
https://github.com/helm/charts/tree/master/stable/prometheus-pushgateway


## Usage

```hcl
module "pushgateway" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-pushgateway?ref=1.0.0"
  enable_service_monitor        = true
  namespace                     = "<NAMESPACE>"
}
```

To deploy Pushwaygateway, execute the module within your namespace. See ```example/pushgateway``` as a template example

Once deployed you should see the associated resources for Pushgateway 

```kubdectl get all -n <NAMESPACE>```

Output should be as follows:

```
NAME                                                      READY   STATUS    RESTARTS   AGE
pod/pushgateway-prometheus-pushgateway-5767794788-nvxvg   1/1     Running   0          34s

NAME                                         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/pushgateway-prometheus-pushgateway   ClusterIP   10.245.57.207   <none>        9091/TCP   34s

NAME                                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/pushgateway-prometheus-pushgateway   1/1     1            1           34s

NAME                                                            DESIRED   CURRENT   READY   AGE
replicaset.apps/pushgateway-prometheus-pushgateway-5767794788   1         1         1       34s 
```

Once all resources are running as above you can then view the console of Pushgateway by port forwarding the Pushgateway service.

``` kubectl port-forward service/pushgateway-prometheus-pushgateway 9091 -n monitoring ```

Browse to ```http://localhost:9091```

## Pushing Custom Metrics

Below are couple of examples of how you can push custom metrics to Pushgateway. 

First ensure you have port-forwarded the Pushgateway service as above 

Using curl you can push a hard-coded metric as follows:

```echo "cpu_utilization 20.25" | curl --data-binary @- http://localhost:9091/metrics/job/my_custom_metrics/instance/10.20.0.1:9000/provider/hetzner```

Have a look at pushgateway’s metrics endpoint:

```
$ curl -L http://localhost:9091/metrics/ | grep cpu_utilization

# TYPE cpu_utilization untyped
cpu_utlization{instance="10.20.0.1:9000",job="my_custom_metrics",provider="hetzner"} 20.25
```

You may also view the above metric in the console.

A more realistic example is one where you can embed the pushing of the metrics within code. Below is an example of using Python to achieve this:

```
import requests

job_name='my_custom_metrics'
instance_name='10.20.0.1:9000'
provider='hetzner'
payload_key='cpu_utilization'
payload_value='21.90'

response = requests.post('http://localhost:9091/metrics/job/{j}/instance/{i}/team/{t}'.format(j=job_name, i=instance_name, t=team_name), data='{k} {v}\n'.format(k=payload_key, v=payload_value))
print(response.status_code)
```

## Scraping Pushgateway Metrics from Prometheus

Lastly if you need to have Prometheus scrape your custom metrics then you will need to ensure that a target pointing to your pushgateway is added to Prometheus' configuration. This can be done by adding a new ```job_name``` to the ```additionalScrapeConfigs``` section to the values file of the prometheus-operator helm chart as below:

```
    prometheusSpec:
      additionalScrapeConfigs:
      - job_name: 'pushgateway'
        honor_labels: true
        static_configs:
        - targets: ['pushgateway-prometheus-pushgateway:9091']
```

## Inputs

| Name                         | Description               | Type    | Default | Required |
|------------------------------|---------------------      |:----:   |:-------:|:--------:|
|   namespace                     namespace of Pushgateway | String  |   ""    |     Yes  |
|   enable_service_monitor     |                           | Boolean |   false |     No   |