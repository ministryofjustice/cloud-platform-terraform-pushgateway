# Default values for prometheus-pushgateway.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.
image:
  repository: prom/pushgateway
  tag: v1.6.2
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 9091
  targetPort: 9091

serviceAccount:
  # Specifies whether a ServiceAccount should be created
  create: true
  # The name of the ServiceAccount to use.
  # If not set and create is true, a name is generated using the fullname template
  name:

replicaCount: 1

# Enable this if you're using https://github.com/coreos/prometheus-operator
serviceMonitor:
  enabled: ${enable_service_monitor}
  namespace: ${namespace}
