locals {
  argo_cd = {
    name          = local.helm_releases[index(local.helm_releases.*.id, "argo-cd")].id
    enabled       = local.helm_releases[index(local.helm_releases.*.id, "argo-cd")].enabled
    chart         = local.helm_releases[index(local.helm_releases.*.id, "argo-cd")].chart
    repository    = local.helm_releases[index(local.helm_releases.*.id, "argo-cd")].repository
    chart_version = local.helm_releases[index(local.helm_releases.*.id, "argo-cd")].chart_version
    namespace     = local.helm_releases[index(local.helm_releases.*.id, "argo-cd")].namespace
  }
  argo_cd_domain_name                  = "argo-cd-${local.domain_suffix}"
  argo_cd_values                               = <<VALUES
nameOverride: argocd
fullnameOverride: ""
kubeVersionOverride: ""
global:
  image:
    repository: quay.io/argoproj/argocd
    tag: v2.1.2
    imagePullPolicy: IfNotPresent
  podAnnotations: {}
  podLabels: {}
  securityContext: {}
  imagePullSecrets: []
  hostAliases: []
  networkPolicy:
    create: false
    defaultDenyIngress: false
apiVersionOverrides:
  certmanager: "" # cert-manager.io/v1
  ingress: "" # networking.k8s.io/v1beta1
createAggregateRoles: false
controller:
  name: application-controller
  image:
    repository: # defaults to global.image.repository
    tag: # defaults to global.image.tag
    imagePullPolicy: # IfNotPresent
  replicas: 1
  enableStatefulSet: false
  args:
    statusProcessors: "20"
    operationProcessors: "10"
    appResyncPeriod: "180"
    selfHealTimeout: "5"
    repoServerTimeoutSeconds: "60"
  logFormat: text
  logLevel: info
  extraArgs: []
  env:
    []
  envFrom: []
  podAnnotations: {}
  podLabels: {}
  containerSecurityContext:
    {}
  containerPort: 8082
  readinessProbe:
    failureThreshold: 3
    initialDelaySeconds: 10
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 1
  livenessProbe:
    failureThreshold: 3
    initialDelaySeconds: 10
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 1
  volumeMounts: []
  volumes: []
  service:
    annotations: {}
    labels: {}
    port: 8082
    portName: https-controller
  nodeSelector: {}
  tolerations: []
  affinity: {}
  priorityClassName: ""
  resources:
    limits:
      cpu: 500m
      memory: 512Mi
    requests:
      cpu: 100m
      memory: 256Mi
  serviceAccount:
    create: true
    name: argocd-application-controller
    annotations: {}
    automountServiceAccountToken: true
  metrics:
    enabled: false
    service:
      annotations: {}
      labels: {}
      servicePort: 8082
    serviceMonitor:
      enabled: false
      interval: 30s
      relabelings: []
      metricRelabelings: []
    rules:
      enabled: false
      spec: []
  clusterAdminAccess:
    enabled: true
  clusterRoleRules:
    enabled: false
    rules: []
dex:
  enabled: true
  name: dex-server
  metrics:
    enabled: false
    service:
      annotations: {}
      labels: {}
    serviceMonitor:
      enabled: false
      interval: 30s
      relabelings: []
      metricRelabelings: []
  image:
    repository: ghcr.io/dexidp/dex
    tag: v2.30.0
    imagePullPolicy: IfNotPresent
  initImage:
    repository:
    tag:
    imagePullPolicy:
  env: []
  envFrom: []
  podAnnotations: {}
  podLabels: {}
  livenessProbe:
    enabled: false
    failureThreshold: 3
    initialDelaySeconds: 10
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 1
  readinessProbe:
    enabled: false
    failureThreshold: 3
    initialDelaySeconds: 10
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 1
  serviceAccount:
    create: true
    name: argocd-dex-server
    annotations: {}
    automountServiceAccountToken: true
  volumeMounts:
    - name: static-files
      mountPath: /shared
  volumes:
    - name: static-files
      emptyDir: {}
  containerPortHttp: 5556
  servicePortHttp: 5556
  servicePortHttpName: http
  containerPortGrpc: 5557
  servicePortGrpc: 5557
  servicePortGrpcName: grpc
  containerPortMetrics: 5558
  servicePortMetrics: 5558
  nodeSelector: {}
  tolerations: []
  affinity: {}
  priorityClassName: ""
  containerSecurityContext:
    {}
  resources:
    limits:
      cpu: 50m
      memory: 64Mi
    requests:
      cpu: 10m
      memory: 32Mi
redis:
  enabled: true
  name: redis
  image:
    repository: redis
    tag: 6.2.4-alpine
    imagePullPolicy: IfNotPresent
  extraArgs: []
  containerPort: 6379
  servicePort: 6379
  env: []
  envFrom: []
  podAnnotations: {}
  podLabels: {}
  nodeSelector: {}
  tolerations: []
  affinity: {}
  priorityClassName: ""
  containerSecurityContext:
    {}
  securityContext:
    runAsNonRoot: true
    runAsUser: 999
  serviceAccount:
    create: false
    name: ""
    annotations: {}
    automountServiceAccountToken: false
  resources:
    limits:
      cpu: 200m
      memory: 128Mi
    requests:
      cpu: 100m
      memory: 64Mi
  volumeMounts: []
  volumes: []
redis-ha:
  enabled: false
  exporter:
    enabled: true
  persistentVolume:
    enabled: false
  redis:
    masterGroupName: argocd
    config:
      save: '""'
  haproxy:
    enabled: true
    metrics:
      enabled: true
  image:
    tag: 6.2.4-alpine
server:
  name: server
  replicas: 1
  autoscaling:
    enabled: false
    minReplicas: 1
    maxReplicas: 5
    targetCPUUtilizationPercentage: 50
    targetMemoryUtilizationPercentage: 50
  image:
    repository: # defaults to global.image.repository
    tag: # defaults to global.image.tag
    imagePullPolicy: # IfNotPresent
  extraArgs:
    - --insecure
  staticAssets:
    enabled: true
  env: []
  lifecycle: {}
  logFormat: text
  logLevel: info
  podAnnotations: {}
  podLabels: {}
  containerPort: 8080
  readinessProbe:
    failureThreshold: 3
    initialDelaySeconds: 10
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 1
  livenessProbe:
    failureThreshold: 3
    initialDelaySeconds: 10
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 1
  volumeMounts: []
  volumes: []
  nodeSelector: {}
  tolerations: []
  affinity: {}
  priorityClassName: ""
  containerSecurityContext:
    {}
  resources:
    limits:
      cpu: 100m
      memory: 128Mi
    requests:
      cpu: 50m
      memory: 64Mi
  certificate:
    enabled: false
    domain: argocd.example.com
    issuer:
      kind: # ClusterIssuer
      name: # letsencrypt
    additionalHosts: []
    secretName: argocd-server-tls
  service:
    annotations: {}
    labels: {}
    type: ClusterIP
    ## For node port default ports
    nodePortHttp: 30080
    nodePortHttps: 30443
    servicePortHttp: 80
    servicePortHttps: 443
    servicePortHttpName: http
    servicePortHttpsName: https
    namedTargetPort: true
    loadBalancerIP: ""
    loadBalancerSourceRanges: []
    externalIPs: []
    externalTrafficPolicy: ""
    sessionAffinity: ""
  metrics:
    enabled: false
    service:
      annotations: {}
      labels: {}
      servicePort: 8083
    serviceMonitor:
      enabled: false
      interval: 30s
      relabelings: []
      metricRelabelings: []
  serviceAccount:
    create: true
    name: argocd-server
    annotations: {}
    automountServiceAccountToken: true
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: nginx
      nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    labels: {}
    ingressClassName: "nginx"
    hosts:
      - ${local.argo_cd_domain_name}
    paths:
      - /
    pathType: Prefix
    extraPaths:
      []
    tls:
    - secretName: argocd-tls-certificate
      hosts:
      - ${local.argo_cd_domain_name}
    https: true
  ingressGrpc:
    enabled: false
    isAWSALB: false
    annotations: {}
    labels: {}
    ingressClassName: ""
    awsALB:
      serviceType: NodePort
      backendProtocolVersion: HTTP2
    hosts:
      []
    paths:
      - /
    pathType: Prefix
    extraPaths:
      []
    tls:
      []
    https: false
  route:
    enabled: false
    hostname: ""
  configEnabled: true
  config:
    url: ${local.argo_cd_domain_name}
    application.instanceLabelKey: argocd.argoproj.io/instance
  configAnnotations: {}
  rbacConfig:
    {}
  rbacConfigAnnotations: {}
  rbacConfigCreate: true
  additionalApplications: []
  additionalProjects: []
  clusterAdminAccess:
    enabled: true
  GKEbackendConfig:
    enabled: false
    spec: {}
  extraContainers: []
repoServer:
  name: repo-server
  replicas: 1
  autoscaling:
    enabled: false
    minReplicas: 1
    maxReplicas: 5
    targetCPUUtilizationPercentage: 50
    targetMemoryUtilizationPercentage: 50
  image:
    repository: # defaults to global.image.repository
    tag: # defaults to global.image.tag
    imagePullPolicy: # IfNotPresent
  extraArgs: []
  env: []
  envFrom: []
  logFormat: text
  logLevel: info
  podAnnotations: {}
  podLabels: {}
  containerPort: 8081
  readinessProbe:
    failureThreshold: 3
    initialDelaySeconds: 10
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 1
  livenessProbe:
    failureThreshold: 3
    initialDelaySeconds: 10
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 1
  volumeMounts: []
  volumes: []
  nodeSelector: {}
  tolerations: []
  affinity: {}
  priorityClassName: ""
  containerSecurityContext:
    {}
  resources:
    limits:
      cpu: 50m
      memory: 128Mi
    requests:
      cpu: 10m
      memory: 64Mi
  service:
    annotations: {}
    labels: {}
    port: 8081
    portName: https-repo-server
  metrics:
    enabled: false
    service:
      annotations: {}
      labels: {}
      servicePort: 8084
    serviceMonitor:
      enabled: false
      interval: 30s
      relabelings: []
      metricRelabelings: []
  serviceAccount:
    create: false
    annotations: {}
    automountServiceAccountToken: true
configs:
  clusterCredentials: []
  gpgKeysAnnotations: {}
  gpgKeys: {}
  knownHostsAnnotations: {}
  knownHosts:
    data:
      ssh_known_hosts: |
        bitbucket.org ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAubiN81eDcafrgMeLzaFPsw2kNvEcqTKl/VqLat/MaB33pZy0y3rJZtnqwR2qOOvbwKZYKiEO1O6VqNEBxKvJJelCq0dTXWT5pbO2gDXC6h6QDXCaHo6pOHGPUy+YBaGQRGuSusMEASYiWunYN0vCAI8QaXnWMXNMdFP3jHAJH0eDsoiGnLPBlBp4TNm6rYI74nMzgz3B9IikW4WVK+dc8KZJZWYjAuORU3jc1c/NPskD2ASinf8v3xnfXeukU0sJ5N6m5E8VLjObPEO+mN2t/FZTMZLiFqPWc/ALSqnMnnhwrNi2rbfg/rd/IpL8Le3pSBne8+seeFVBoGqzHM9yXw==
        github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
        gitlab.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KWjbjTDTdDkoohFzgbEY=
        gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf
        gitlab.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9
        ssh.dev.azure.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7Hr1oTWqNqOlzGJOfGJ4NakVyIzf1rXYd4d7wo6jBlkLvCA4odBlL0mDUyZ0/QUfTTqeu+tm22gOsv+VrVTMk6vwRU75gY/y9ut5Mb3bR5BV58dKXyq9A9UeB5Cakehn5Zgm6x1mKoVyf+FFn26iYqXJRgzIZZcZ5V6hrE0Qg39kZm4az48o0AUbf6Sp4SLdvnuMa2sVNwHBboS7EJkm57XQPVU3/QpyNLHbWDdzwtrlS+ez30S3AdYhLKEOxAG8weOnyrtLJAUen9mTkol8oII1edf7mWWbWVf0nBmly21+nZcmCTISQBtdcyPaEno7fFQMDD26/s0lfKob4Kw8H
        vs-ssh.visualstudio.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7Hr1oTWqNqOlzGJOfGJ4NakVyIzf1rXYd4d7wo6jBlkLvCA4odBlL0mDUyZ0/QUfTTqeu+tm22gOsv+VrVTMk6vwRU75gY/y9ut5Mb3bR5BV58dKXyq9A9UeB5Cakehn5Zgm6x1mKoVyf+FFn26iYqXJRgzIZZcZ5V6hrE0Qg39kZm4az48o0AUbf6Sp4SLdvnuMa2sVNwHBboS7EJkm57XQPVU3/QpyNLHbWDdzwtrlS+ez30S3AdYhLKEOxAG8weOnyrtLJAUen9mTkol8oII1edf7mWWbWVf0nBmly21+nZcmCTISQBtdcyPaEno7fFQMDD26/s0lfKob4Kw8H
  tlsCertsAnnotations: {}
  tlsCerts:
    {}
  repositoryCredentials: {}
  credentialTemplates: {}
  secret:
    createSecret: true
    annotations: {}
    githubSecret: ""
    gitlabSecret: ""
    bitbucketServerSecret: ""
    bitbucketUUID: ""
    gogsSecret: ""
    extra:
      {}
    argocdServerTlsConfig:
      {}
openshift:
  enabled: false
VALUES
}

module "argo_cd_namespace" {
  count = local.argo_cd.enabled ? 1 : 0

  source = "../modules/kubernetes-namespace"
  name   = local.argo_cd.namespace
}

resource "helm_release" "argo_cd" {
  count = local.argo_cd.enabled ? 1 : 0

  name        = local.argo_cd.name
  chart       = local.argo_cd.chart
  repository  = local.argo_cd.repository
  version     = local.argo_cd.chart_version
  namespace   = module.argo_cd_namespace[count.index].name
  max_history = var.helm_release_history_size

  values = compact([
    local.argo_cd_values
])

  depends_on = [
    helm_release.calico_daemonset
  ]
}

output "argo_cd_domain_name" {
  value       = local.argo_cd.enabled ? local.argo_cd_domain_name : null
  description = "Argo-cd dashboards address"
}

output "argo_cd_get_admin_password" {
  value       = local.argo_cd.enabled ? "kubectl get secrets -n ${local.argo_cd.namespace} argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo" : null
  description = "Command which gets admin password from kubernetes secret"
}
