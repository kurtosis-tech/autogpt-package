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

    env_vars = {}

    for env_var_key, env_var_value in args.items():
        env_vars[env_var_key] = str(env_var_value)

    if "MEMORY_BACKEND" in args and args["MEMORY_BACKEND"] == "weaviate":
        plan.print("Using the '{0}' memory backend".format(env_vars["MEMORY_BACKEND"]))
        if "USE_WEAVIATE_EMBEDDED" in args and ["USE_WEAVIATE_EMBEDDED"] == "True":
            plan.print("The weaviate backend will be running in embedded mode; not starting a separate container")
        else:
            weaviate = launch_weaviate(plan, args)
            weaviate_args_to_add_if_they_dont_exist = {}
            weaviate_args_to_add_if_they_dont_exist["WEAVIATE_HOST"] = weaviate.ip_address
            weaviate_args_to_add_if_they_dont_exist["WEAVIATE_PORT"] = str(WEAVIATE_PORT)
            weaviate_args_to_add_if_they_dont_exist["WEAVIATE_PROTOCOL"] = WEAVIATE_PORT_PROTOCOL
            weaviate_args_to_add_if_they_dont_exist["WEAVIATE_USERNAME"] = ""
            weaviate_args_to_add_if_they_dont_exist["WEAVIATE_PASSWORD"] = ""
            weaviate_args_to_add_if_they_dont_exist["WEAVIATE_API_KEY"] = ""
            # if the user just passes "weaviate" without setting any args we just set everything up for them
            # otherwise the user might provide an online address or something which we preserve
            for weaviate_arg_key, weaviate_arg_value in weaviate_args_to_add_if_they_dont_exist.items():
                if weaviate_arg_key not in env_vars:
                    env_vars[weaviate_arg_key] = weaviate_arg_value
    elif "MEMORY_BACKEND" in env_vars and env_vars["MEMORY_BACKEND"] == "local":
        plan.print("Using the '{0}' memory backend".format(env_vars["MEMORY_BACKEND"]))
    elif "MEMORY_BACKEND" in env_vars and env_vars["MEMORY_BACKEND"] == ""
    elif env_vars.get("MEMORY_BACKEND", "redis") == "redis":
        plan.print("Using the '{0}' memory backend".format(env_vars["MEMORY_BACKEND"]))
        redis_server = redis_module.run(plan, {'redis-image': REDIS_IMAGE})
        # redis has to run inside the enclave so we set it up for them and change the vars
        env_vars["MEMORY_BACKEND"] = "redis"
        env_vars["REDIS_HOST"] = redis_server["hostname"]
        env_vars["REDIS_PORT"] =  str(redis_server["client-port"])
        env_vars["REDIS_PASSWORD"] = ""
    else:
        plan.print("Memory backend needs to be one of redis, local, weaviate, milvus or piencone. We default to redis if nothing is specified. Got '{0}' which isn't a valid value".format(env_vars["MEMORY_BACKEND"]))

    plan.print("Starting AutoGpt with environment variables set to\n{0}".format(env_vars))

    plan.add_service(
        name = "autogpt",
        config = ServiceConfig(
            image = AUTOGPT_IMAGE,
            entrypoint = ["sleep", "9999999"],
            env_vars = env_vars,
        )
    )

    if "MEMORY_BACKEND" in args and args["MEMORY_BACKEND"] == "weaviate":
        plan.exec(
            service_name = "autogpt",
            recipe = ExecRecipe(
                command = ["pip", "install", "weaviate-client"]
            )
        )


def launch_weaviate(plan, args):
    weaviate = plan.add_service(
        name = "weaviate",
        config = ServiceConfig(
            image = WEAVIATE_IMAGE,
            ports = {
                WEAVIATE_PORT_ID: PortSpec(number = WEAVIATE_PORT, transport_protocol = "TCP")
            },
            env_vars = {
                "QUERY_DEFAULTS_LIMIT": str(25),
                "AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED": 'true',
                "PERSISTENCE_DATA_PATH": '/var/lib/weaviate',
                "DEFAULT_VECTORIZER_MODULE": 'none',
                "CLUSTER_HOSTNAME": 'node1'
            }
        )
    )

    return weaviate
