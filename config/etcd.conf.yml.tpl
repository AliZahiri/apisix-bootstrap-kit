
name: ${ETCD_NAME:-default}
data-dir: /bitnami/etcd/data
advertise-client-urls: http://0.0.0.0:${ETCD_PORT:-2379}
listen-client-urls: http://0.0.0.0:${ETCD_PORT:-2379}
