# cloud-platform-terraform-pushgateway

[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-pushgateway/all.svg?style=flat-square)](https://github.com/ministryofjustice/cloud-platform-terraform-pushgateway/releases)

Terraform module that deploy cloud-platform prometheus pushgateway.

## Overview

The Prometheus Pushgateway is an intermediary service which allows ephemeral and batch jobs to expose its metrics to Prometheus. Since these kinds of jobs may not exist long enough to be scraped, they can instead push their metrics to a Pushgateway and the Prometheus scrapes the metrics from it. Read the [prometheus-pushgateway](https://github.com/prometheus/pushgateway) repo for more details.

This module uses terraform's ```helm_release``` resource to deploy the ```prometheus-community/prometheus-pushgateway``` helm chart into your namespace. More information on this chart can be found here:
https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-pushgateway


## Usage

See [this example](example/pushgateway.tf)

## Inputs

  | Name                         | Description               | Type    | Default | Required |
  |------------------------------|---------------------      |:----:   |:-------:|:--------:|
  |   namespace                     namespace of Pushgateway | String  |   ""    |     Yes  |
  |   enable_service_monitor     |                           | Boolean |   true |     No   |

  ## Outputs

  Once deployed you should see the associated resources for Pushgateway 

  ```kubdectl get all -n <NAMESPACE>```

  Output should be as follows:

  ```
  NAME                                                                  READY   STATUS    RESTARTS   AGE
  pod/<NAMESPACE>-pushgateway-prometheus-pushgateway-7b96f94bgd5l4   1/1     Running   0          3h42m

  NAME                                         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
  service/<NAMESPACE>-pushgateway-prometheus-pushgateway   ClusterIP   10.245.57.207   <none>        9091/TCP   34s

  NAME                                                 READY   UP-TO-DATE   AVAILABLE   AGE
  deployment.apps/<NAMESPACE>-pushgateway-prometheus-pushgateway   1/1     1            1           34s

  NAME                                                            DESIRED   CURRENT   READY   AGE
  replicaset.apps/<NAMESPACE>-pushgateway-prometheus-pushgateway-5767794788   1         1         1       34s 
  ```

  You can access your pushgateway from the service 
  ```http://<NAMESPACE>-pushgateway-prometheus-pushgateway:9091/metrics/job/<NAMESPACE>-pushgateway-prometheus-pushgateway/``` 

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

  For more details on using pushgateway and pushing metrics from inside your app, check the guidance [here](https://prometheus.io/docs/instrumenting/pushing/).

  ## Scraping Pushgateway Metrics from Prometheus

  By default, this module create a serviceMonitor resource which specifies how your pushgateway metrics can be retrieved from your pushgateway service. This will allow the prometheus-operator to monitor and pull metrics automatically from this service.
