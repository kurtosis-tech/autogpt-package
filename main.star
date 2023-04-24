AUTOGPT_IMAGE="significantgravitas/auto-gpt:0.2.2"
REDIS_IMAGE="redis/redis-stack-server:latest"

OPENAI_API_KEY_ARG="OPENAI_API_KEY"

redis_module = import_module("github.com/kurtosis-tech/redis-package/main.star")

def run(plan, args):

    if OPENAI_API_KEY_ARG not in args:
        fail("{0} is a required argument that needs to be passed to this script".format(OPENAI_API_KEY_ARG))

    redis_server = redis_module.run(plan, {'redis-image': REDIS_IMAGE})

    env_vars = {
        "MEMORY_BACKEND": "redis",
        "REDIS_HOST": redis_server["hostname"],
        "REDIS_PORT": str(redis_server["client-port"]),
        "REDIS_PASSWORD": ""
    }

    for env_var_key, env_var_value in args.items():
        env_vars[env_var_key] = str(env_var_value)

    plan.print("Starting AutoGpt with environment variables set to\n{0}".format(env_vars))

    plan.add_service(
        name = "autogpt",
        config = ServiceConfig(
            image = AUTOGPT_IMAGE,
            entrypoint = ["sleep", "9999999"],
            env_vars = env_vars,
        )
    )
