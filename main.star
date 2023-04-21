AUTOGPT_IMAGE="significantgravitas/auto-gpt:0.2.2"
REDIS_IMAGE="redis/redis-stack-server:latest"
WEAVIATE_IMAGE="semitechnologies/weaviate:1.18.3"

OPENAI_API_KEY_ARG="OPENAI_API_KEY"

WEAVIATE_PORT = 8080
WEAVIATE_PORT_ID = "http"
WEAVIATE_PORT_PROTOCOL = WEAVIATE_PORT_ID

redis_module = import_module("github.com/kurtosis-tech/redis-package/main.star")

def run(plan, args):

    if OPENAI_API_KEY_ARG not in args:
        fail("{0} is a required argument that needs to be passed to this script".format(OPENAI_API_KEY_ARG))

    env_vars = {
        "MEMORY_BACKEND": "redis",
        "REDIS_HOST": redis_server["hostname"],
        "REDIS_PORT": str(redis_server["client-port"]),
        "REDIS_PASSWORD": ""
    }

    for env_var_key, env_var_value in args.items():
        env_vars[env_var_key] = str(env_var_value)

    plan.print("Starting AutoGpt with environment variables set to\n{0}".format(env_vars))
        "OPENAI_API_KEY": args[OPENAI_API_KEY_ARG],
    }

    if "MEMORY_BACKEND" in args and args["MEMORY_BACKEND"] == "weaviate":
        if "USE_WEAVIATE_EMBEDDED" in args and ["USE_WEAVIATE_EMBEDDED"] == False:
            weaviate = plan.launch_weaviate(plan, args)
            env_vars["WEAVIATE_HOST"] = weaviate.ip_address
            env_vars["WEAVIATE_PORT"] = WEAVIATE_PORT
            env_vars["WEAVIATE_PROTOCOL"] = WEAVIATE_PORT_PROTOCOL
            env_vars["WEAVIATE_USERNAME"] = ""
            env_vars["WEAVIATE_PASSWORD"] = ""
            env_vars["WEAVIATE_API_KEY"] = ""            
    if "MEMORY_BACKEND" in args[ENV_VARS_ARG] and args[ENV_VARS_ARG]["MEMORY_BACKEND"] == "local":
        env_vars["MEMORY_BACKEND"] = "local"
    else:
        redis_server = redis_module.run(plan, {'redis-image': REDIS_IMAGE})
        env_vars["MEMORY_BACKEND"] = "redis"
        env_vars["REDIS_HOST"] = redis_server["hostname"]
        env_vars["REDIS_PORT"] =  str(redis_server["client-port"])
        env_vars["REDIS_PASSWORD"] = ""


    plan.add_service(
        name = "autogpt",
        config = ServiceConfig(
            image = AUTOGPT_IMAGE,
            entrypoint = ["sleep", "9999999"],
            env_vars = env_vars,
        )
    )


def launch_weaviate(plan, args):
    weaviate = plan.add_service(
        name = "weaviate",
        config = ServiceConfig(
            ports = {
                WEAVIATE_PORT_ID: PortSpec(number = WEAVIATE_PORT, transport_protocol = "TCP")
            },
            env_vars = {
                QUERY_DEFAULTS_LIMIT: 25
                AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED: 'true'
                PERSISTENCE_DATA_PATH: '/var/lib/weaviate'
                DEFAULT_VECTORIZER_MODULE: 'none'
                CLUSTER_HOSTNAME: 'node1'
            }
        )
    )

    return weaviate
