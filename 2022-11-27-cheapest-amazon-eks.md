# Test

Code:

```bash
# renovate: datasource=helm depName=kube-prometheus-stack registryUrl=https://prometheus-community.github.io/helm-charts
KUBE_PROMETHEUS_STACK_HELM_CHART_VERSION="48.2.3"

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
tee "${TMP_DIR}/${CLUSTER_FQDN}/helm_values-kube-prometheus-stack.yml" << EOF
defaultRules:
  rules:
    etcd: false
    kubernetesSystem: false
    kubeScheduler: false
alertmanager:
  config:
    global:
      smtp_smarthost: "mailhog.mailhog.svc.cluster.local:1025"
      smtp_from: "alertmanager@${CLUSTER_FQDN}"
    route:
      group_by: ["alertname", "job"]
      receiver: email-notifications
      routes:
        - receiver: email-notifications
          matchers: [ '{severity=~"warning|critical"}' ]
    receivers:
      - name: email-notifications
        email_configs:
          - to: "notification@${CLUSTER_FQDN}"
            require_tls: false
  ingress:
    enabled: true
    ingressClassName: nginx
    annotations:
      forecastle.stakater.com/expose: "true"
      forecastle.stakater.com/icon: https://raw.githubusercontent.com/stakater/ForecastleIcons/master/alert-manager.png
      forecastle.stakater.com/appName: Alert Manager
      nginx.ingress.kubernetes.io/auth-url: https://oauth2-proxy.${CLUSTER_FQDN}/oauth2/auth
      nginx.ingress.kubernetes.io/auth-signin: https://oauth2-proxy.${CLUSTER_FQDN}/oauth2/start?rd=\$scheme://\$host\$request_uri
    hosts:
      - alertmanager.${CLUSTER_FQDN}
    paths: ["/"]
    pathType: ImplementationSpecific
    tls:
      - hosts:
          - alertmanager.${CLUSTER_FQDN}
# https://github.com/grafana/helm-charts/blob/main/charts/grafana/values.yaml
grafana:
  defaultDashboardsEnabled: false
  serviceMonitor:
    enabled: true
  ingress:
    enabled: true
    ingressClassName: nginx
    annotations:
      forecastle.stakater.com/expose: "true"
      forecastle.stakater.com/icon: https://raw.githubusercontent.com/stakater/ForecastleIcons/master/grafana.png
      forecastle.stakater.com/appName: Grafana
      nginx.ingress.kubernetes.io/auth-url: https://oauth2-proxy.${CLUSTER_FQDN}/oauth2/auth
      nginx.ingress.kubernetes.io/auth-signin: https://oauth2-proxy.${CLUSTER_FQDN}/oauth2/start?rd=\$scheme://\$host\$request_uri
      nginx.ingress.kubernetes.io/configuration-snippet: |
        auth_request_set \$email \$upstream_http_x_auth_request_email;
        proxy_set_header X-Email \$email;
    hosts:
      - grafana.${CLUSTER_FQDN}
    paths: ["/"]
    pathType: ImplementationSpecific
    tls:
      - hosts:
          - grafana.${CLUSTER_FQDN}
  datasources:
    datasource.yaml:
      apiVersion: 1
      datasources:
        - name: Prometheus
          type: prometheus
          url: http://kube-prometheus-stack-prometheus.kube-prometheus-stack:9090/
          access: proxy
          isDefault: true
  dashboardProviders:
    dashboardproviders.yaml:
      apiVersion: 1
      providers:
        - name: "default"
          orgId: 1
          folder: ""
          type: file
          disableDeletion: false
          editable: true
          options:
            path: /var/lib/grafana/dashboards/default
  dashboards:
    default:
      # 2023-03-30
      1860-node-exporter-full:
        # renovate: depName="Node Exporter Full"
        gnetId: 1860
        revision: 30
        datasource: Prometheus
      # 2017-11-24
      3662-prometheus-2-0-overview:
        gnetId: 3662
        revision: 2
        datasource: Prometheus
      # 2019-02-27
      9852-stians-disk-graphs:
        gnetId: 9852
        revision: 1
        datasource: Prometheus
      # 2020-03-31
      12006-kubernetes-apiserver:
        gnetId: 12006
        revision: 1
        datasource: Prometheus
      # 2018-10-29
      9614-nginx-ingress-controller:
        gnetId: 9614
        revision: 1
        datasource: Prometheus
      # 2020-03-09
      11875-kubernetes-ingress-nginx-eks:
        gnetId: 11875
        revision: 1
        datasource: Prometheus
      # 2021-09-22
      15038-external-dns:
        gnetId: 15038
        revision: 1
        datasource: Prometheus
      # 2021-04-27
      14314-kubernetes-nginx-ingress-controller-nextgen-devops-nirvana:
        gnetId: 14314
        revision: 2
        datasource: Prometheus
      # 2022-07-06
      13473-portefaix-kubernetes-cluster-overview:
        gnetId: 13473
        revision: 2
        datasource: Prometheus
      # https://grafana.com/orgs/imrtfm/dashboards - https://github.com/dotdc/grafana-dashboards-kubernetes
      # 2023-07-10
      15760-kubernetes-views-pods:
        gnetId: 15760
        revision: 20
        datasource: Prometheus
      # 2023-08-04
      15757-kubernetes-views-global:
        gnetId: 15757
        revision: 31
        datasource: Prometheus
      # 2023-08-04
      15758-kubernetes-views-namespaces:
        gnetId: 15758
        revision: 26
        datasource: Prometheus
      # 2023-05-10
      15759-kubernetes-views-nodes:
        gnetId: 15759
        revision: 19
        datasource: Prometheus
      # 2023-07-04
      15761-kubernetes-system-api-server:
        gnetId: 15761
        revision: 13
        datasource: Prometheus
      # 2023-07-04
      15762-kubernetes-system-coredns:
        gnetId: 15762
        revision: 13
        datasource: Prometheus
      # 2023-07-04
      19105-prometheus:
        gnetId: 19105
        revision: 1
        datasource: Prometheus
      # 2022-05-06
      16237-cluster-capacity:
        gnetId: 16237
        revision: 1
        datasource: Prometheus
      # 2022-05-06
      16236-pod-statistic:
        gnetId: 16236
        revision: 1
        datasource: Prometheus
      # 2023-08-01
      19268-prometheus:
        gnetId: 19268
        revision: 1
        datasource: Prometheus
  grafana.ini:
    server:
      root_url: https://grafana.${CLUSTER_FQDN}
    # Use oauth2-proxy instead of default Grafana Oauth
    auth.basic:
      enabled: false
    auth.proxy:
      auto_sign_up: true
      enabled: true
      header_name: X-Email
      header_property: email
    users:
      allow_sign_up: false
      auto_assign_org: true
      auto_assign_org_role: Admin
  smtp:
    enabled: true
    host: "mailhog.mailhog.svc.cluster.local:1025"
    from_address: grafana@${CLUSTER_FQDN}
kubeControllerManager:
  enabled: false
kubeEtcd:
  enabled: false
kubeScheduler:
  enabled: false
kubeProxy:
  enabled: false
prometheusOperator:
  tls:
    enabled: false
  admissionWebhooks:
    enabled: false
prometheus:
  ingress:
    enabled: true
    ingressClassName: nginx
    annotations:
      forecastle.stakater.com/expose: "true"
      forecastle.stakater.com/icon: https://raw.githubusercontent.com/cncf/artwork/master/projects/prometheus/icon/color/prometheus-icon-color.svg
      forecastle.stakater.com/appName: Prometheus
      nginx.ingress.kubernetes.io/auth-url: https://oauth2-proxy.${CLUSTER_FQDN}/oauth2/auth
      nginx.ingress.kubernetes.io/auth-signin: https://oauth2-proxy.${CLUSTER_FQDN}/oauth2/start?rd=\$scheme://\$host\$request_uri
    paths: ["/"]
    pathType: ImplementationSpecific
    hosts:
      - prometheus.${CLUSTER_FQDN}
    tls:
      - hosts:
          - prometheus.${CLUSTER_FQDN}
  prometheusSpec:
    externalLabels:
      cluster: ${CLUSTER_FQDN}
    externalUrl: https://prometheus.${CLUSTER_FQDN}
    ruleSelectorNilUsesHelmValues: false
    serviceMonitorSelectorNilUsesHelmValues: false
    podMonitorSelectorNilUsesHelmValues: false
    retentionSize: 1GB
    walCompression: true
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: gp2
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 2Gi
EOF
helm upgrade --install --version "${KUBE_PROMETHEUS_STACK_HELM_CHART_VERSION}" --namespace kube-prometheus-stack --create-namespace --values "${TMP_DIR}/${CLUSTER_FQDN}/helm_values-kube-prometheus-stack.yml" kube-prometheus-stack prometheus-community/kube-prometheus-stack
```
