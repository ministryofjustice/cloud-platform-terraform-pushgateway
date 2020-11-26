# cloud-platform-terraform-monitoring

Terraform module that deploy cloud-platform pushgateway solution.

## Overview
Pushgateway allows ephemeral and batch jobs to expose its metrics to Prometheus. The batch/ephemeral jobs push the metrics to Pushgateway and the Prometheus scrapes the metrics from it.

The Prometheus Pushgateway is an intermediary service which allows ephemeral and batch jobs to expose its metrics to Prometheus. Since these kinds of jobs may not exist long enough to be scraped, they can instead push their metrics to a Pushgateway and the Prometheus scrapes the metrics from it. Read the [prometheus-pushgateway](https://github.com/prometheus/pushgateway) repo for more details.

This module uses terraform's ```helm_release``` resource to deploy the ```prometheus-community/prometheus-pushgateway``` helm chart into your namespace. More information on this chart can be found here:
https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-pushgateway


## Usage

```hcl
module "pushgateway" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-pushgateway?ref=1.1.0"
  namespace                     = var.namespace
}
```

To deploy Pushwaygateway, execute the module within your namespace. See ```example/pushgateway``` example

Once deployed you should see the associated resources for Pushgateway 

```kubdectl get all -n <NAMESPACE>```

Output should be as follows:

```
NAME                                                                  READY   STATUS    RESTARTS   AGE
pod/<namespace>-pushgateway-prometheus-pushgateway-7b96f94bgd5l4   1/1     Running   0          3h42m

NAME                                         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/<namespace>-pushgateway-prometheus-pushgateway   ClusterIP   10.245.57.207   <none>        9091/TCP   34s

NAME                                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/<namespace>-pushgateway-prometheus-pushgateway   1/1     1            1           34s

NAME                                                            DESIRED   CURRENT   READY   AGE
replicaset.apps/<namespace>-pushgateway-prometheus-pushgateway-5767794788   1         1         1       34s 
```

## Pushing Custom Metrics

Below example shows how you can push custom metrics to Pushgateway. 

Using curl you can push a hard-coded metric as follows:

```echo "cpu_utilization 20.25" | curl --data-binary @- http://localhost:9091/metrics/job/my_batch_job_custom_metrics```

You can view the console of Pushgateway by port forwarding the Pushgateway service.

``` kubectl port-forward service/<namespace>-pushgateway-prometheus-pushgateway 9091 -n <namespace> ```

Browse to ```http://localhost:9091```


Look at pushgateway’s metrics endpoint:

```
$ curl -L http://localhost:9091/metrics/ | grep cpu_utilization

# TYPE cpu_utilization untyped
cpu_utlization{job="my_batch_job_custom_metrics"} 20.25
```

You can also view the above metric in the console: http://localhost:9091/metrics

For more details on using pushgateway and pushing metrics 

## Scraping Pushgateway Metrics from Prometheus


```

## Inputs

| Name                         | Description               | Type    | Default | Required |
|------------------------------|---------------------      |:----:   |:-------:|:--------:|
|   namespace                     namespace of Pushgateway | String  |   ""    |     Yes  |
|   enable_service_monitor     |                           | Boolean |   false |     No   |

## Outputs
