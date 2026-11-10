
apisix:
  node_listen: 9080
  enable_ipv6: false

deployment:
  admin:
    enable_admin_ui: true
    allow_admin:
      - 0.0.0.0/0

    admin_key:
      - name: "admin"
        key: ${{APISIX_ADMIN_KEY}}
        role: admin

      - name: "viewer"
        key: ${{APISIX_VIEWER_KEY}}
        role: viewer

  etcd:
    host:
      - "http://etcd:2379"
    prefix: "/apisix"
    timeout: 60

plugin_attr:
  prometheus:
    export_addr:
      ip: "0.0.0.0"
      port: 9091
