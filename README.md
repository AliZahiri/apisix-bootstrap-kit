# APISIX Bootstrap Kit

A local Docker Compose lab for Apache APISIX, etcd, the embedded APISIX Dashboard, and a sample gateway route. It provides a small, reproducible environment for learning gateway configuration and testing routes.

This is a local evaluation stack, not a production deployment. Its published ports bind to `127.0.0.1`; do not remove those bindings or attach untrusted containers to the Compose network. Production deployments need separately managed secrets, authenticated and encrypted etcd, access controls, backups, and an operational upgrade plan.

## Requirements

- Docker Engine with Docker Compose v2
- Bash
- OpenSSL

## Start

```bash
git clone https://github.com/AliZahiri/apisix-bootstrap-kit.git
cd apisix-bootstrap-kit
./runIT.sh
```

On first run, the script creates a private `.env` with unique random Admin API keys and starts the stack. Compose passes the keys to APISIX as environment variables; the tracked configuration contains no secret values. The script does not print the keys or remove existing Docker volumes. The Admin API and Dashboard are available only from the local machine.

To render configuration and validate Compose without starting containers:

```bash
./runIT.sh --prepare-only
docker compose config --quiet
python3 scripts/validate_compose.py
```

## Endpoints

| Service | Local URL |
| --- | --- |
| Gateway | <http://127.0.0.1:8080/> |
| Embedded Dashboard | <http://127.0.0.1:9180/ui/> |
| Admin API | <http://127.0.0.1:9180/apisix/admin/routes> |
| Prometheus metrics | <http://127.0.0.1:9091/apisix/prometheus/metrics> |

The Dashboard is embedded in the pinned APISIX image. On first access, enter the `APISIX_ADMIN_KEY` from `.env` in the Dashboard settings. The legacy standalone Dashboard image has been removed because its 3.0.1 release is only tested with APISIX 3.0.x.

## Add a sample route

The example route proxies `/google` to `google.com`. Create it through the Admin API after the stack is healthy:

```bash
admin_key="$(sed -n 's/^APISIX_ADMIN_KEY=//p' .env)"
curl --fail-with-body --silent --show-error \
  --request PUT \
  --header "X-API-KEY: ${admin_key}" \
  --header 'Content-Type: application/json' \
  --data '{
    "uri": "/google",
    "methods": ["GET"],
    "upstream": {
      "type": "roundrobin",
      "nodes": {"google.com:443": 1},
      "scheme": "https"
    }
  }' \
  http://127.0.0.1:9180/apisix/admin/routes/1
unset admin_key
```

Then request <http://127.0.0.1:8080/google>.

## Stop and preserve data

```bash
docker compose down
```

This stops the stack and preserves the named etcd volume. To permanently erase the lab's configuration data, review the Compose project name and explicitly remove its volume with `docker volume rm <project>_etcd_data`.

## Configuration

- `APISIX_IMAGE_TAG` selects the APISIX image; the default is `3.19.0-debian`.
- `APISIX_ADMIN_KEY` and `APISIX_VIEWER_KEY` are generated as distinct 64-character hexadecimal values on first run and must remain private.
- Host ports default to HTTP `8080`, HTTPS `8443`, Admin API/Dashboard `9180`, and metrics `9091`. Set `APISIX_HTTP_PORT`, `APISIX_HTTPS_PORT`, `APISIX_ADMIN_PORT`, or `APISIX_METRICS_PORT` in `.env` to use other free ports in the range 1024-65535.
- The generated `.env` file is excluded from Git and restricted to the current user.

## Validation

```bash
bash -n runIT.sh
shellcheck runIT.sh
./runIT.sh --prepare-only
docker compose config --quiet
python3 scripts/validate_compose.py
```
