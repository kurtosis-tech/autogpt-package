milvus = import_module("github.com/kurtosis-tech/autogpt-package/src/milvus.star")

AUTOGPT_IMAGE="significantgravitas/auto-gpt:latest"
REDIS_IMAGE="redis/redis-stack-server:latest"
WEAVIATE_IMAGE="semitechnologies/weaviate:1.18.3"

AUTOGPT_SERVICE_NAME = "autogpt"

OPENAI_API_KEY_ARG="OPENAI_API_KEY"

WEAVIATE_PORT = 8080
WEAVIATE_PORT_ID = "http"
WEAVIATE_PORT_PROTOCOL = WEAVIATE_PORT_ID

ARGS_TO_SKIP_FOR_ENV_VARS = ["__plugin_branch_to_use", "__plugin_repo_to_use"]

DEFAULT_PLUGINS_DIRNAME = "plugins"

redis_module = import_module("github.com/kurtosis-tech/redis-package/main.star")
plugins = import_module("github.com/kurtosis-tech/autogpt-package/plugins.star")

def run(plan, args):

    if OPENAI_API_KEY_ARG not in args:
        fail("{0} is a required argument that needs to be passed to this script".format(OPENAI_API_KEY_ARG))

    env_vars = {}

    # this is purely for CI test of plugins
    # replaces the download url from master.zip to the name of the branch
    # this does a mass replace
    plugin_branch_to_use = None
    plugin_repo_to_use = None
    if "__plugin_branch_to_use" in args:
        plugin_branch_to_use = args["__plugin_branch_to_use"]
    if "__plugin_repo_to_use" in args:
        plugin_repo_to_use = args["__plugin_repo_to_use"]

    for env_var_key, env_var_value in args.items():
        if env_var_key in ARGS_TO_SKIP_FOR_ENV_VARS:
            continue
        env_vars[env_var_key] = str(env_var_value)
    
    plugins_dir = env_vars.get("PLUGINS_DIR", DEFAULT_PLUGINS_DIRNAME)

    is_memory_backend_milvus = False

    if "MEMORY_BACKEND" in env_vars and env_vars["MEMORY_BACKEND"] == "weaviate":
        plan.print("Using the '{0}' memory backend".format(env_vars["MEMORY_BACKEND"]))
        if "USE_WEAVIATE_EMBEDDED" in env_vars and env_vars["USE_WEAVIATE_EMBEDDED"] == "True":
            plan.print("The weaviate backend will be running in embedded mode; not starting a separate container")
        elif "WEAVIATE_HOST" in env_vars and "WEAVIATE_PORT" in env_vars:
            plan.print("We're using the Weaviate at {}:{}. Please make sure that you have also provided the right values for WEAVIATE_USERNAME, WEAVIATE_PASSWORD, WEAVIATE_API_KEY as needed".format(env_vars["WEAVIATE_HOST"], env_vars["WEAVIATE_PORT"]))
        else:
            weaviate = launch_weaviate(plan)
            weaviate_args_to_add_if_they_dont_exist = {}
            weaviate_args_to_add_if_they_dont_exist["WEAVIATE_HOST"] = weaviate.ip_address
            weaviate_args_to_add_if_they_dont_exist["WEAVIATE_PORT"] = str(WEAVIATE_PORT)
            weaviate_args_to_add_if_they_dont_exist["WEAVIATE_PROTOCOL"] = WEAVIATE_PORT_PROTOCOL
            weaviate_args_to_add_if_they_dont_exist["WEAVIATE_USERNAME"] = ""
            weaviate_args_to_add_if_they_dont_exist["WEAVIATE_PASSWORD"] = ""
            weaviate_args_to_add_if_they_dont_exist["WEAVIATE_API_KEY"] = ""
            weaviate_args_to_add_if_they_dont_exist["MEMORY_INDEX"] = "AutoGPT"
            # if the user just passes "weaviate" without setting any args we just set everything up for them
            # otherwise the user might provide an online address or something which we preserve
            for weaviate_arg_key, weaviate_arg_value in weaviate_args_to_add_if_they_dont_exist.items():
                if weaviate_arg_key not in env_vars:
                    env_vars[weaviate_arg_key] = weaviate_arg_value
    elif "MEMORY_BACKEND" in env_vars and env_vars["MEMORY_BACKEND"] == "milvus":
        is_memory_backend_milvus = True
        plan.print("Using the '{0}' memory backend".format(env_vars["MEMORY_BACKEND"]))

        if "MILVUS_ADDR" in env_vars and env_vars["MILVUS_ADDR"] != "":
            plan.print("Using Milvus from the cloud on address '{}'".format(env_vars["MILVUS_ADDR"]))
            
            milvus_required_args = ["MILVUS_USERNAME", "MILVUS_PASSWORD"]
            for env_var_key in milvus_required_args:
                if env_var_key not in env_vars:
                    plan.print("{0} are required keys for Milvus in the cloud. Seems like one of them is missing.")
                    fail("{0} is a required env var that needs to be set for Milvus in the cloud to work but was missing".format(env_var_key))

        else:
            plan.print("Preparing for using Milvus locally")
            milvus_address = milvus.launch(plan)
            env_vars["MILVUS_ADDR"] = milvus_address

        env_vars["MILVUS_SECURE"] = str(False)
        env_vars["MILVUS_COLLECTION"] = "autogpt"
    elif env_vars.get("MEMORY_BACKEND", "redis") == "redis":
        env_vars["MEMORY_BACKEND"] = "redis"
        plan.print("Using the '{0}' memory backend".format(env_vars["MEMORY_BACKEND"]))
        if "REDIS_HOST" in env_vars and "REDIS_PORT" in env_vars:
            plan.print("As REDIS_HOST & REDIS_PORT are provided we will just use the remote Redis instance")
        else:
            plan.print("Setting up Redis")
            redis_server = redis_module.run(plan, {'redis-image': REDIS_IMAGE})
            # redis has to run inside the enclave so we set it up for them and change the vars
            env_vars["REDIS_HOST"] = redis_server["hostname"]
            env_vars["REDIS_PORT"] =  str(redis_server["client-port"])
            env_vars["REDIS_PASSWORD"] = ""
    elif "MEMORY_BACKEND" in env_vars and env_vars["MEMORY_BACKEND"]in ("local", "pinecone"):
        plan.print("Using the '{0}' memory backend".format(env_vars["MEMORY_BACKEND"]))
    else:
        plan.print("Memory backend needs to be one of redis, local, weaviate, milvus or piencone. We default to redis if nothing is specified. Got '{0}' which isn't a valid value".format(env_vars["MEMORY_BACKEND"]))

    plan.print("Starting AutoGpt with environment variables set to\n{0}".format(env_vars))

    plan.add_service(
        name = AUTOGPT_SERVICE_NAME,
        config = ServiceConfig(
            image = AUTOGPT_IMAGE,
            entrypoint = ["sleep", "9999999"],
            env_vars = env_vars,
        )
    )

    plan.exec(
        service_name = AUTOGPT_SERVICE_NAME,
        recipe = ExecRecipe(
            command = ["mkdir", "/app/data"],
        )
    )

    if "MEMORY_BACKEND" in env_vars and env_vars["MEMORY_BACKEND"] == "weaviate":
        plan.exec(
            service_name = AUTOGPT_SERVICE_NAME,
            recipe = ExecRecipe(
                command = ["pip", "install", "weaviate-client"]
            )
        )
        
    if is_memory_backend_milvus:
        plan.exec(
            service_name = AUTOGPT_SERVICE_NAME,
            recipe = ExecRecipe(
                command = ["pip", "install", "pymilvus"]
            )
        )

    if 'ALLOWLISTED_PLUGINS' in env_vars:
        plan.exec(
            service_name = AUTOGPT_SERVICE_NAME,
            recipe = ExecRecipe(
                command = ["mkdir", "/app/plugins"]
            )
        )

        plugins_to_download = list()
        plugins_already_in_download_list = list()
        plugins_names = env_vars['ALLOWLISTED_PLUGINS'].split(',')
        for plugin_name in plugins_names:
            if plugin_name in plugins.plugins_map:
                plugin = plugins.plugins_map[plugin_name]
                if plugin_name in plugins_already_in_download_list:
                    continue
                plugins_to_download.append(plugin)
                plugins_already_in_download_list.append(plugin_name)
            else:
                fail("Invalid plugin name {0}.  The supported plugins are: {1}. You can add support for a new plugin by creating an issue or PR at {2}".format(plugin_name, ", ".join(plugins.plugins_map.keys()), "https://github.com/kurtosis-tech/autogpt-package"))

        if plugins_to_download:
            download_plugins(plan, plugins_dir, plugins_to_download, plugin_branch_to_use, plugin_repo_to_use)
            install_plugins(plan)



def launch_weaviate(plan):
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

def download_plugins(plan, plugins_dir, plugins_to_download, plugin_branch_to_use=None, plugin_repo_to_use = None):
    for plugin in plugins_to_download:
        url = plugins.get_plugin_url(plugin, plugin_branch_to_use, plugin_repo_to_use)
        plugin_filename = plugins.get_filename(plugin)
        download_and_run_command = "wget -O ./{0}/{1} {2}".format(plugins_dir, plugin_filename, url)
        plan.exec(
            service_name = AUTOGPT_SERVICE_NAME,
            recipe = ExecRecipe(
                command = ["/bin/sh", "-c", download_and_run_command],
            )
        )


def install_plugins(plan):
    plan.exec(
        service_name = AUTOGPT_SERVICE_NAME,
        recipe = ExecRecipe(
            command = ["/bin/sh", "-c", "python scripts/install_plugin_deps.py"],
        )
    )
