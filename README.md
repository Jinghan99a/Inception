 🚀 Inception Project: WordPress Containerized Architecture

This README provides an overview of the architecture and mechanisms used to deploy a full-stack WordPress website using Docker Compose.

---

 🏗️ Project Overview & Architecture

This project utilizes Docker Compose to orchestrate three independent containers, linked via a custom Docker network, creating a secure, performant, and persistent web environment.

| Component | Role | Technology | Port |
| :--- | :--- | :--- | :--- |
| **NGINX** | Front-end / Reverse Proxy | Debian / NGINX | **443 (HTTPS)** |
| **WordPress** | Application Layer | PHP-FPM / WordPress | 9000 (Internal) |
| **MariaDB** | Database | MariaDB Server | 3306 (Internal) |

🔄 Request Flow

A visual representation of how a user's request is handled:

1.  **User Browser**
2.  $\downarrow$ **HTTPS** (port 443)
3.  **NGINX Container** (SSL Termination)
4.  $\downarrow$ **FastCGI Protocol** (port 9000)
5.  **WordPress Container** (PHP-FPM)
6.  $\downarrow$ **MySQL Protocol** (port 3306)
7.  **MariaDB Container**

---

📦 Container Deep Dive

1. NGINX Container: Reverse Proxy + SSL Termination

NGINX acts as the secure **"front door"** of the architecture.

* **Listens on:** Port **443 (HTTPS)**, fulfilling the security requirement.
* **Role: Reverse Proxy & SSL Termination:**
    * It receives the encrypted **HTTPS** request from the client.
    * It holds the **SSL certificate and private key** to decrypt the traffic (SSL Termination).
    * It forwards the decrypted, unencrypted **HTTP request** via the **FastCGI Protocol** to the WordPress container.
* **Benefits:** Centralized SSL management and a secure barrier for backend services.

2. WordPress Container: PHP-FPM Application Layer

This container is dedicated to running the WordPress core application logic.

* **Core Technology:** **PHP-FPM** (FastCGI Process Manager).
* **Function:** PHP-FPM maintains a **pool of persistent PHP interpreter processes**. When a request arrives from NGINX via the FastCGI protocol, PHP-FPM passes it to an idle process for fast execution, avoiding the slow process spawning inherent in traditional CGI.
* **Connection:** Connects to the MariaDB container via the MySQL protocol (port 3306).
* **Listens on:** Port 9000 (Internal only).

3. MariaDB Container: Database Service

This container stores all dynamic data required by the WordPress application.

* **Role:** Storage for all site data (posts, users, settings).
* **Connection:** Listens on port 3306 (Internal only).
* **Requirement:** The container is configured for **data persistence** using Docker Volumes.

---

💾 Data Persistence Mechanism

To ensure data integrity across container restarts and VM reboots, the project uses Docker **Volumes** (specifically, Bind Mounts) for key application directories.

| Volume Name | Container Path | Host Path Example | Stored Content | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **`wp_data`** | `/var/www/wordpress` | `/home/user/data/wordpress` | WordPress files, themes, media uploads | Shared by NGINX and WordPress for serving content. |
| **`db_data`** | `/var/lib/mysql` | `/home/user/data/mariadb` | MariaDB database files (`.ibd`, `.frm`) | Ensures all database records persist. |

> **Q: Why Persistence?**
>
> * Data survives container deletion (`docker-compose down`).
> * Data remains intact after a Virtual Machine reboot.
> * Facilitates easy backup directly from the host machine's filesystem.

---

🐳 Docker Execution Overview

* **Containerization:** Utilizes Docker for lightweight virtualization, ensuring each service has an isolated filesystem, process space, and network, making it faster and more resource-efficient than a traditional Virtual Machine setup.
* **Docker Compose:** Used to define the multi-container application (`docker-compose.yml`), managing service dependencies (`depends_on`), unified networking, and volume declarations for a single-command deployment (`docker-compose up`).

---

附录：中文版本 (Chinese Version)

 🏗️ 项目整体架构

本项目使用 Docker Compose 搭建了一个完整的 WordPress 网站，包含三个独立的容器，它们通过自定义网络相互通信，构成了安全、高性能且持久化的 Web 环境。

| 组件 | 角色 | 技术 | 端口 |
| :--- | :--- | :--- | :--- |
| **NGINX** | 前端 / 反向代理 | Debian / NGINX | **443 (HTTPS)** |
| **WordPress** | 应用层 | PHP-FPM / WordPress | 9000 (内部) |
| **MariaDB** | 数据库 | MariaDB Server | 3306 (内部) |

📦 三个容器如何协同工作

1. NGINX 容器 (反向代理 + SSL)

作为网站 “前门”，监听 *43 端口 (HTTPS)*。

反向代理 + SSL 终止： NGINX 负责接收并 解密用户的 HTTPS 请求（SSL 终止），然后将解密后的请求通过 FastCGI 协议转发给 WordPress 容器。
作用：集中处理 SSL 加密、提供静态文件和安全防护。

2. WordPress 容器 (应用层)

* **核心技术：** **PHP-FPM (FastCGI 进程管理器)**。
* **作用：** 运行常驻内存的 PHP 进程池，快速响应 NGINX 转发的 FastCGI 请求，执行 WordPress 代码逻辑，并连接 MariaDB 进行数据读写。
* **监听：** 9000 端口（仅容器内部访问）。

3. MariaDB 容器 (数据库)

* **作用：** 存储所有网站数据（文章、用户、设置）。
* **连接：** 接收来自 WordPress 容器的 SQL 查询，监听 3306 端口（仅容器内部访问）。

💾 数据持久化机制

本项目使用 Docker *卷（Volumes）*来实现数据持久化：

| 卷名称 | 容器内路径 | 存储内容 |
| :--- | :--- | :--- |
| **`wp_data`** | `/var/www/wordpress` | WordPress 文件、主题、插件、上传的媒体 |
| **`db_data`** | `/var/lib/mysql` | MariaDB 数据库文件（.ibd, .frm 等） |

持久化意义：
>
> * 容器被删除后，数据不会丢失。
> * 重启虚拟机后，网站配置和数据仍然存在。


----------------------------------------------------------------------------------------------------------------------------------------------------------------------
Key Architectural Concepts

1. Reverse Proxy & SSL Termination

| Concept | Explanation |
| :--- | :--- |
| **Reverse Proxy** | A server that sits **in front** of one or more backend web servers (like WordPress). It intercepts client requests and forwards them internally, hiding the backend's real IP. |
| **SSL/TLS** | A cryptographic protocol ensuring the **confidentiality** and **integrity** of data transmitted over the network (HTTPS). |
| **SSL Termination** | The critical process where the **Reverse Proxy (NGINX)** uses the SSL certificate and key to **decrypt** the incoming HTTPS traffic. The traffic is then usually forwarded **unencrypted** internally to the application server. |
| **Benefits** | Centralizes security management, reduces CPU load on backend servers, and shields internal IPs from the public internet. |

---

2. PHP-FPM (FastCGI Process Manager)

| Concept | Explanation |
| :--- | :--- |
| **FastCGI Protocol** | A fast, binary protocol used for communication between the **Web Server** (e.g., NGINX) and the **dynamic language interpreter** (e.g., PHP-FPM). It improves upon the slow, older CGI protocol. |
| **PHP-FPM** | The **FastCGI Process Manager**. It maintains a **pool of persistent PHP interpreter processes (worker processes)** that are kept alive in memory. |
| **Process Pool** | A collection of continuously running PHP worker processes managed by FPM. When NGINX forwards a request via FastCGI, FPM immediately hands it to an idle process. |
| **Benefits** | Provides **High Performance and Concurrency** because the PHP environment is loaded only once, eliminating the need to start a new interpreter process for every single request. |

---

核心架构概念

1. 反向代理与 SSL 终止

| 概念 | 解释 |
| :--- | :--- |
| **反向代理** | 位于用户和后端 Web 服务器（如 WordPress）**之间**的服务器。它拦截客户端请求并将其转发到内部服务，同时隐藏后端真实 IP。 |
| **SSL/TLS** | 一种加密协议，用于确保数据在网络传输过程中的**机密性**和**完整性**（HTTPS）。 |
| **SSL 终止** | 关键过程：**反向代理 (NGINX)** 使用 SSL 证书和密钥来**解密**传入的 HTTPS 流量。流量随后通常以**非加密**形式转发给内部应用服务器。 |
| **优点** | 集中化安全管理，减轻后端服务器的 CPU 负担，并将内部 IP 与公共网络隔离。 |

---

2. PHP-FPM (FastCGI 进程管理器)

| 概念 | 解释 |
| :--- | :--- |
| **FastCGI 协议** | 一种用于 Web 服务器 (NGINX) 和 **动态语言解释器** (PHP-FPM) 之间通信的快速二进制协议。它解决了传统 CGI 效率低下的问题。 |
| **PHP-FPM** | **FastCGI 进程管理器**。它维护着一组**常驻内存的 PHP 解释器进程池（工作进程）**。 |
| **进程池** | FPM 管理着一组持续运行的 PHP 工作进程。当 NGINX 通过 FastCGI 转发请求时，FPM 会立即将其交给一个空闲进程处理。 |
| **优点** | 实现了**高性能和高并发**，因为 PHP 环境只需加载一次，避免了每次请求都重复创建新的解释器进程。 |

您好！您提供的 `docker-compose.yml` 文件展示了如何为 WordPress 和 MariaDB **实现数据持久化 (Data Persistence)**。这是通过 Docker Compose 的 **`volumes`** 部分，并结合了 **Bind Mount (绑定挂载)** 的方式来实现的。

## 💾 数据持久化的原理和配置解析

数据持久化的目的是确保容器被删除、重启或重新构建时，重要的应用程序数据（如数据库记录、上传的文件、WordPress 核心文件等）不会丢失。

-----

### 1. 卷的定义 (Volumes Definition)

在 YAML 文件的根级别，`volumes` 部分定义了两个命名的卷 (`wp` 和 `mariadb`)。

```yaml
volumes:
  wp:
    driver: local
    driver_opts:
      type: 'none'
      o: bind
      device: /$HOME/data/wordpress
  mariadb:
    driver: local
    driver_opts:
      type: 'none'
      o: bind
      device: /$HOME/data/mariadb
```

  * **`wp` 和 `mariadb`：** 这是卷的名称，供下方的服务引用。
  * **`driver: local`：** 指定使用本地驱动程序来管理卷。
  * **`driver_opts` (驱动程序选项)：** **这是实现“绑定挂载”的关键。**
      * **`type: 'none'`：** 告诉 Docker Compose 不要使用标准卷管理，而是使用一个自定义的类型。
      * **`o: bind`：** **明确指定使用 Bind Mount（绑定挂载）**，将主机上的目录直接映射到容器内。
      * **`device: /$HOME/data/wordpress` / `/$HOME/data/mariadb`：** 指定主机（运行 Docker 的虚拟机或物理机）上对应的**绝对路径**。Docker 会将主机的这个路径映射到容器中。

> **总结：** 这段配置定义了两个卷，将您的主机路径 `$HOME/data/wordpress` 和 `$HOME/data/mariadb` 永久地链接到了 Docker 环境中。

-----

### 2. 卷在服务中的应用 (Volume Application in Services)

在每个服务定义中，通过 `volumes` 关键字引用这些卷，将主机目录映射到容器内的关键路径。

#### A. MariaDB 服务

```yaml
services:
  mariadb:
    # ...
    volumes:
      - mariadb:/var/lib/mysql # <- 这里是关键
```

  * **`mariadb` (卷名)：** 引用了上方定义的主机路径 `$HOME/data/mariadb`。
  * **`/var/lib/mysql` (容器路径)：** 这是 MariaDB 存储其数据库文件（如 `.ibd`, `.frm`）的默认目录。
  * **结果：** 容器启动后，所有数据库操作都会直接读写主机上的 `$HOME/data/mariadb` 目录。**数据库数据实现了持久化。**

#### B. WordPress 服务

```yaml
  wordpress:
    # ...
    volumes:
      - wp:/var/www/wordpress # <- 这里是关键
```

  * **`wp` (卷名)：** 引用了上方定义的主机路径 `$HOME/data/wordpress`。
  * **`/var/www/wordpress` (容器路径)：** 这是 WordPress 应用程序文件、主题、插件和上传媒体的根目录。
  * **结果：** 容器启动后，所有 WordPress 核心文件和用户上传的内容都存储在主机上的 `$HOME/data/wordpress` 目录。**WordPress 应用数据实现了持久化。**

#### C. Nginx 服务 (共享卷)

```yaml
  nginx:
    # ...
    volumes:
      - wp:/var/www/wordpress # <- 共享卷
```

  * **`wp` (卷名)：** Nginx 也挂载了同一个 `wp` 卷。
  * **结果：** Nginx 可以直接访问和提供 WordPress 容器中存放的静态文件（CSS、JS、用户上传的图片等），因为它们都指向同一个主机目录。

-----

## 🔑 额外配置解析

  * **`networks`：** 定义了一个名为 `inception` 的桥接网络，确保所有三个容器 (`mariadb`, `wordpress`, `nginx`) 都在同一个内部网络中，可以互相通过服务名（例如 `mariadb`）进行通信。
  * **`depends_on`：** 设置了容器的启动依赖关系（例如，`wordpress` 必须等 `mariadb` 启动，`nginx` 必须等 `wordpress` 启动），保证服务按正确的顺序启动。
  * **`ports`：** **只有 Nginx** 将容器的 443 端口映射到了主机的 443 端口，允许外部访问。其他服务（MariaDB 和 WordPress）只使用了 `expose`，表示它们仅在容器网络内暴露端口。
