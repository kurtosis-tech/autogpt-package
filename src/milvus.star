# ETCD
ETCD_IMAGE = "quay.io/coreos/etcd:v3.5.5"
ETCD_SERVICE_NAME = "milvus-etcd"
ETCD_COMMAND = ["etcd", "-advertise-client-urls=http://127.0.0.1:2379", "-listen-client-urls", "http://0.0.0.0:2379", "--data-dir", "/etcd"]
ETCD_ENV_VARS = {
    "ETCD_AUTO_COMPACTION_MODE": "revision",
    "ETCD_AUTO_COMPACTION_RETENTION": str(1000),
    "ETCD_QUOTA_BACKEND_BYTES": str(4294967296),
    "ETCD_SNAPSHOT_COUNT": str(50000)
}
ETCD_HTTP_PORT_ID = "http"
ETCD_HTTP_PORT_NUMBER = 2379

# MINIO
MINIO_IMAGE = "minio/minio:RELEASE.2022-03-17T06-34-49Z"
MINIO_SERVICE_NAME = "milvus-minio"
MINIO_COMMAND = ["minio", "server", "/minio_data"]
MINIO_ENV_VARS = {
    "MINIO_ACCESS_KEY": "minioadmin",
    "MINIO_SECRET_KEY": "minioadmin",
}
MINIO_HTTP_PORT_ID = "http"
MINIO_HTTP_PORT_NUMBER = 9000
MINIO_HEALTH_CHECK_ENDPOINT = "/minio/health/live"

# MILVUS
MILVUS_IMAGE = "milvusdb/milvus:v2.2.8"
MILVUS_SERVICE_NAME = "milvus-standalone"
MILVUS_COMMAND = ["milvus", "run", "standalone"]
MILVUS_GRPC_PORT_ID = "grpc"
MILVUS_GRPC_PORT_NUMBER = 19530
MILVUS_GRPC_PORT_WAIT = "2m"
MILVUS_HTTP_PORT_ID = "http"
MILVUS_HTTP_PORT_NUMBER = 9091
MILVUS_HTTP_PORT_WAIT = "2m"
MILVUS_ETCD_ENV_VARS_KEY = "ETCD_ENDPOINTS"
MILVUS_MINIO_ENV_VARS_KEY = "MINIO_ADDRESS"
MILVUS_READY_CONDITION_FIELD = "code"
MILVUS_READY_CONDITION_ASSERTION = "=="
MILVUS_READY_CONDITION_TARGET_VALUE = 200
MILVUS_READY_CONDITION_INTERVAL = "30s"
MILVUS_READY_CONDITION_TIMEOUT = "2m"

# COMMON
SERVICE_ADDRESS_TEMPLATE = "{}:{}"

def launch(plan):

    etcd_ports = {
        ETCD_HTTP_PORT_ID: PortSpec(number = ETCD_HTTP_PORT_NUMBER),
    }

    etcd = plan.add_service(
        name = ETCD_SERVICE_NAME,
        config = ServiceConfig(
            image = ETCD_IMAGE,
            ports = etcd_ports,
            env_vars = ETCD_ENV_VARS,
            cmd = ETCD_COMMAND,
        )
    )

    minio_get_recipe = GetHttpRequestRecipe(
        port_id = MINIO_HTTP_PORT_ID,
        endpoint = MINIO_HEALTH_CHECK_ENDPOINT,
    )

    minio_ready_condition = ReadyCondition(
        recipe = minio_get_recipe,
        field = MILVUS_READY_CONDITION_FIELD,
        assertion = MILVUS_READY_CONDITION_ASSERTION,
        target_value = MILVUS_READY_CONDITION_TARGET_VALUE,
        interval = MILVUS_READY_CONDITION_INTERVAL,
        timeout = MILVUS_READY_CONDITION_TIMEOUT,
    )

    minio_ports = {
        MINIO_HTTP_PORT_ID: PortSpec(number = MINIO_HTTP_PORT_NUMBER),
    }

    minio = plan.add_service(
        name = MINIO_SERVICE_NAME,
        config = ServiceConfig(
            image = MINIO_IMAGE,
            ports = minio_ports,
            env_vars = MINIO_ENV_VARS,
            cmd = MINIO_COMMAND,
            ready_conditions = minio_ready_condition,
        )
    )

    etcd_ednpoints = SERVICE_ADDRESS_TEMPLATE.format(etcd.ip_address, etcd.ports[ETCD_HTTP_PORT_ID].number)
    minio_address = SERVICE_ADDRESS_TEMPLATE.format(minio.ip_address, minio.ports[MINIO_HTTP_PORT_ID].number)

    milvus_env_vars = {
        MILVUS_ETCD_ENV_VARS_KEY: etcd_ednpoints,
        MILVUS_MINIO_ENV_VARS_KEY: minio_address,
    }

    milvus_ports = {
        MILVUS_GRPC_PORT_ID: PortSpec(number = MILVUS_GRPC_PORT_NUMBER, wait = MILVUS_GRPC_PORT_WAIT),
        MILVUS_HTTP_PORT_ID: PortSpec(number = MILVUS_HTTP_PORT_NUMBER, wait = MILVUS_HTTP_PORT_WAIT),
    }

    milvus = plan.add_service(
        name = MILVUS_SERVICE_NAME,
        config = ServiceConfig(
            image = MILVUS_IMAGE,
            ports = milvus_ports,
            env_vars = milvus_env_vars,
            cmd = MILVUS_COMMAND,
        )
    )

    milvus_address = SERVICE_ADDRESS_TEMPLATE.format(milvus.ip_address, milvus.ports[MILVUS_GRPC_PORT_ID].number)

    return milvus_address
