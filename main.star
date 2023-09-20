redis_module = import_module("github.com/kurtosis-tech/redis-package/main.star")
plugins = import_module("./plugins.star")
common = import_module("./src/common.star")

AUTOGPT_IMAGE = "significantgravitas/auto-gpt:v0.4.2"
AUTOGPT_IMAGE_ARG = "AUTOGPT_IMAGE"
REDIS_IMAGE = "redis/redis-stack-server:latest"

AUTOGPT_SERVICE_NAME = "autogpt"

OPENAI_API_KEY_ARG = "OPENAI_API_KEY"

WEAVIATE_PORT = 8080
WEAVIATE_PORT_ID = "http"
WEAVIATE_PORT_PROTOCOL = WEAVIATE_PORT_ID

SKIP_ENV_VARS_VALIDATION = "__skip_env_vars_validation"
SKIP_ENV_VARS_DEFAULT_VALUES_SET = "__skip_env_vars_default_values_set"
ARGS_TO_SKIP_FOR_ENV_VARS = ["__plugin_branch_to_use", "__plugin_repo_to_use", SKIP_ENV_VARS_VALIDATION, SKIP_ENV_VARS_DEFAULT_VALUES_SET]

DEFAULT_PLUGINS_DIRNAME = "plugins"
# Chrome seems to be having some issues starting up in Docker
# We set USE_WEB_BROWSER=DEFAULT_WEB_BROWSER unless the user specifies something else
# TODO fix this after https://github.com/Significant-Gravitas/Auto-GPT/issues/3779 is fixed
DEFAULT_WEB_BROWSER = "firefox"

ALLOW_LISTED_PLUGINS_ENV_VAR_KEY = 'ALLOWLISTED_PLUGINS'

# Replace OpenAI with GPT4All
GPT4_ALL_ARG = "GPT_4ALL"
MODEL_ARG = "GPT_4ALL_CUSTOM_MODEL_URL"
LOCAL_AI_IMAGE = "quay.io/go-skynet/local-ai:latest"
LOCAL_AI_SERVICE = "local-ai"
DEFAULT_MODEL_URL = "https://gpt4all.io/models/ggml-gpt4all-j.bin"

def run(plan, args):

    is_gpt4all = args.get(GPT4_ALL_ARG, False)
    if is_gpt4all:
        local_ai_service = plan.add_service(
            name = LOCAL_AI_SERVICE,
            config = ServiceConfig(
                image = LOCAL_AI_IMAGE,
                ports = {
                    "http": PortSpec(number = 8080, transport_protocol="TCP", wait=None)
                },
            )
        )
        plan.print("Downloading the model; this will take a while")
        model_url = args.get(MODEL_ARG, DEFAULT_MODEL_URL)
        model_name = model_url.split("/")[-1]
        # AutoGPT checks for this
        model_name = "gpt-3.5-turbo"
        wget_str = " ".join(["wget", model_url, "-O", "models/{0}".format(model_name)])
        plan.exec(
            service_name=LOCAL_AI_SERVICE,
            recipe = ExecRecipe(
                command = ["/bin/sh", "-c", "mkdir models/ && " + wget_str + " > /dev/null 2>&1"] 
            )
        )
        plan.wait(
            service_name=LOCAL_AI_SERVICE,
            recipe = GetHttpRequestRecipe(
                port_id="http",
                endpoint="/v1/models",
                extract={
                    "model-id": ".data[0].id",
                }
            ),
            field = "extract.model-id",
            assertion = "==",
            target_value=model_name,
            timeout="5m"
        )
        if OPENAI_API_KEY_ARG not in args:
            args[OPENAI_API_KEY_ARG] = "sk---anystirnghere"
        args["OPENAI_API_BASE_URL"] = "http://{}:8080/v1".format(local_ai_service.ip_address)
        args["SMART_LLM_MODEL"] = model_name


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
        if env_var_key == ALLOW_LISTED_PLUGINS_ENV_VAR_KEY and type(env_var_value) == "list":
            # arg items expects the values to be the string
            # so if user input is a list, convert it into a string which can
            # be parsed later
            env_vars[env_var_key] = (",").join(env_var_value)
        else:
            env_vars[env_var_key] = str(env_var_value)
    
    plugins_dir = env_vars.get("PLUGINS_DIR", DEFAULT_PLUGINS_DIRNAME)


    if ALLOW_LISTED_PLUGINS_ENV_VAR_KEY in env_vars:      
        plugins_names = env_vars[ALLOW_LISTED_PLUGINS_ENV_VAR_KEY].split(',')

        # validate plugins names
        plugins.validatePluginNames(plugins_names)
        
        # this means if its running in old CI configurations (AutoGPT CI config before adding validations) we need to know this for not creating a breaking change
        isRunningInOldCIConfig = plugin_branch_to_use != None and plugin_repo_to_use != None 

        # validate plugins 
        # skip validation if it explicity requested in the arguments or if it's running in an old CI config
        skip_env_vars_validation = SKIP_ENV_VARS_VALIDATION in args
        
        if not isRunningInOldCIConfig and not skip_env_vars_validation:
            are_all_required_env_vars_set, missing_required_env_vars = plugins.areAllRequiredEnvVarsSet(env_vars, plugins_names)
            if not are_all_required_env_vars_set:
                fail("Error while validating the required env var for plugins. The missing required env vars are '{0}'".format(missing_required_env_vars))

        # set plugins default env vars values
        # skip plugin default env vars set if it explicity requested in the arguments or if it's running in an old CI config
        skip_env_vars_default_values_set = SKIP_ENV_VARS_DEFAULT_VALUES_SET in args

        if not isRunningInOldCIConfig and not skip_env_vars_default_values_set:
            default_plugin_env_vars_values = plugins.getPluginsEnvVarsDefaultValues(plugins_names, env_vars)
            env_vars.update(default_plugin_env_vars_values)
    
    if "USE_WEB_BROWSER" not in env_vars:
        env_vars["USE_WEB_BROWSER"] = DEFAULT_WEB_BROWSER

    if "MEMORY_BACKEND" in env_vars and env_vars["MEMORY_BACKEND"] == "redis":
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
    elif env_vars.get("MEMORY_BACKEND", "local"):
        plan.print("Using the local memory backend")
    else:
        plan.print("Memory backend needs to be one of redis, local. We default to local if nothing is specified. Got '{0}' which isn't a valid value".format(env_vars["MEMORY_BACKEND"]))

    plan.print("Starting AutoGpt with environment variables set to\n{0}".format(env_vars))

    autogpt_image = args.get(AUTOGPT_IMAGE_ARG, AUTOGPT_IMAGE)

    plan.add_service(
        name = AUTOGPT_SERVICE_NAME,
        config = ServiceConfig(
            image = autogpt_image,
            entrypoint = ["sleep", "9999999"],
            env_vars = env_vars,
        )
    )

    init_env_file_command = "echo '{0}' > /app/.env".format("\n".join(["{0}={1}".format(k, v) for (k, v) in env_vars.items()]))
    plan.exec(
        service_name = "autogpt",
        recipe = ExecRecipe(
            command = ["/bin/sh", "-c", init_env_file_command]
        )
    )

    if ALLOW_LISTED_PLUGINS_ENV_VAR_KEY in env_vars:
        plan.exec(
            service_name = AUTOGPT_SERVICE_NAME,
            recipe = ExecRecipe(
                command = ["mkdir", "-p", "/app/plugins"]
            )
        )

        plugins_to_download = list()
        plugins_already_in_download_list = list()
        
        for plugin_name in plugins_names:
            if plugin_name in plugins.plugins_map:
                plugin = plugins.plugins_map[plugin_name]
                if plugin_name in plugins_already_in_download_list:
                    continue
                plugins_to_download.append(plugin)
                plugins_already_in_download_list.append(plugin_name)
            else:
                fail("Invalid plugin name {0}. The supported plugins are: {1}. You can add support for a new plugin by creating an issue or PR at {2}".format(plugin_name, ", ".join(plugins.plugins_map.keys()), common.KURTOSIS_AUTOGPT_PACKAGE_URL))

        if plugins_to_download:
            download_plugins(plan, plugins_dir, plugins_to_download, plugin_branch_to_use, plugin_repo_to_use)
            install_plugins(plan)


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