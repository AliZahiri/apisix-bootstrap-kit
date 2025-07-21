conf:
  listen:
    host: 0.0.0.0
    port: 9000

  allow_list:
    - 0.0.0.0/0

  etcd:
    endpoints:
      - "http://etcd:2379"
    mtls:
      key_file: ""
      cert_file: ""
      ca_file: ""

  log:
    error_log:
      level: warn
      file_path:
        logs/error.log
    access_log:
      file_path:
        logs/access.log

authentication:
  secret: secret
  expire_time: 3600
  users:
    - username: admin
      password: ${APISIX_ADMIN_KEY}
    - username: viewer
      password: ${APISIX_VIEWER_KEY}

plugins:
  - api-breaker
  - authz-keycloak
  - basic-auth
  - batch-requests
  - consumer-restriction
  - cors
  - echo
  - fault-injection
  - grpc-transcode
  - hmac-auth
  - http-logger
  - ip-restriction
  - jwt-auth
  - kafka-logger
  - key-auth
  - limit-conn
  - limit-count
  - limit-req
  - openid-connect
  - prometheus
  - proxy-cache
  - proxy-mirror
  - proxy-rewrite
  - redirect
  - referer-restriction
  - request-id
  - request-validation
  - response-rewrite
  - serverless-post-function
  - serverless-pre-function
  - sls-logger
  - syslog
  - tcp-logger
  - udp-logger
  - uri-blocker
  - wolf-rbac
  - zipkin
  - server-info
  - traffic-split
