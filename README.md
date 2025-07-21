# 🧰 APISIX Bootstrap Kit

A ready-to-use Docker-based toolkit to bootstrap a complete [Apache APISIX](https://apisix.apache.org/) gateway environment with:

- ✅ **APISIX Core** (v3.9.0)
- 🗃️ **etcd** (Bitnami v3.5.11)
- 📊 **APISIX Dashboard**
- ⚙️ **Auto-provisioning Script** for initial sample routes
- 🔐 **Secrets externalized via `.env`**
- 🛠️ **Flexible templated configuration**

---

## 📦 Features

- Preconfigured for local testing and fast deployment
- Sample `/google` route setup
- Control API, Prometheus port, and dashboard all exposed
- `.env` driven for secret injection (API keys, etc.)
- Shell script (`runIT.sh`) handles full environment bootstrap

---

## 🚀 Getting Started

### 1️⃣ Clone the Repo

```bash
git clone https://github.com/YOUR_USERNAME/apisix-bootstrap-kit.git
cd apisix-bootstrap-kit
```

### 2️⃣ Create Your `.env`

Create a file named `.env` in the root folder:

```env
APISIX_ADMIN_KEY=YourAdminSecret
APISIX_VIEWER_KEY=YourViewerSecret

ETCD_NAME=default
ETCD_PORT=2379
```

> 🔒 Keep `.env` in `.gitignore` (already included)

### 3️⃣ Run the Bootstrap Script

```bash
sudo ./runIT.sh
```

> The script will:
> - Create all required folders under `/opt/apisix`
> - Render configuration files using `envsubst`
> - Launch all services via Docker Compose
> - Auto-provision a sample route

---

## 📍 Access Points

| Service        | URL                                |
|----------------|-------------------------------------|
| Gateway (HTTP) | http://localhost:80                |
| Admin API      | http://localhost:9180/apisix/admin |
| Dashboard UI   | http://localhost:9100              |

---

## 🔐 Credentials

- **Admin Key**: Loaded from `.env`
- **Dashboard Login**:
  - Username: `admin`
  - Password: same as `APISIX_ADMIN_KEY`

---

## 🧪 Sample API Test

```bash
curl http://localhost/google
```

Or

```bash
curl -H "X-API-KEY: $APISIX_ADMIN_KEY" http://localhost:9180/apisix/admin/routes
```

---

## 📁 Folder Structure

```text
.
├── config/
│   ├── apisix_cnf.yml.tpl
│   ├── apisix_dsh_cnf.yml.tpl
│   └── etcd.conf.yml.tpl
├── docker-compose.yml
├── runIT.sh
├── .env
└── README.md
```

---

## 📋 License

MIT License – feel free to modify and extend.

---
