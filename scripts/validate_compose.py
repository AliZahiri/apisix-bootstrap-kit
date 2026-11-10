#!/usr/bin/env python3
"""Check security and persistence contracts in the rendered Compose model."""

import json
import subprocess


model = json.loads(
    subprocess.check_output(
        ["docker", "compose", "config", "--format", "json"], text=True
    )
)
services = model["services"]
apisix = services["apisix"]
etcd = services["etcd"]

ports = apisix.get("ports", [])
assert {port["target"] for port in ports} == {9080, 9443, 9180, 9091}
assert all(port["host_ip"] == "127.0.0.1" for port in ports)
assert not etcd.get("ports"), "etcd must not publish host ports"
assert etcd.get("healthcheck"), "APISIX startup must wait for healthy etcd"
assert any(
    volume.get("type") == "volume" and volume.get("target") == "/etcd-data"
    for volume in etcd.get("volumes", [])
), "etcd data must use a persistent named volume"
assert apisix.get("depends_on", {}).get("etcd", {}).get("condition") == "service_healthy"
assert "latest" not in apisix["image"].lower()
assert "latest" not in etcd["image"].lower()

print("Compose exposure, health, image pinning, and data persistence checks passed.")
